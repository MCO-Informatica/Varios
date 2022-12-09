#Include 'Protheus.ch'

#Define NAO_E_RETORNO  'BR_BRANCO'
#Define SIM_E_RETORNO  'BR_AMARELO'
#Define Pula_Linha Chr(13)+Chr(10)

STATIC lTK271 	   := .F.
STATIC nAbaAtu 	   := 1


//-----------------------------------------------------------------------
// Rotina | CSFA110    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Agenda do Operador Certisign.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA110()
	Local lContinua    := .T.
	Local cArqLck      := GetPathSemaforo() + 'csfa110' + __cUserID + cEmpAnt + cFilAnt + '.lck' //Nome da rotina + ID user + Nº empresa + Nº Filial => csfa1100001230102.lck
	Local nHandle      := 0
	Local cRet         := ''
	Local cMvAgOp	   := 'AGOP'
	
	Private cCadastro  := 'Agenda do Operador Certisign'
	Private cU7_COD    := ''
	Private cU7_NOME   := ''
	Private cU7_TIPO   := ''
	Private cU7_OPERAD := ''
	Private cU7_CODVEN := ''
	Private cA3_XCANAL := ''
	
	Private aDadosOp   := {}
	Private aSTADISC   := {}	
	
	Private aHeader1   := {}
	Private aHeader2   := {}
	Private aHeader3   := {}
	
	Private aCpoGd     := {}
	
	Private aCOLS1     := {}
	Private aCOLS2     := {}
	Private aCOLS3     := {}
	
	Private a110Fil    := { 1, 1, Ctod( Space( 8 ) ), Ctod( Space( 8 ) ), Space( 50 ), Space( 50 ), 1, Space(40), 1 }
	
	Private nOrdemQry  := 1
	Private lReportQry := .F.
	
	Private cUC_XDIPROP := CriaVar("UC_XDIPROP")
	Private cUC_XHIPROP := ""
	Private lAcessoLck := .T. //O Acesso será por controle de SEMAFORO (.LCK) ou parâmetro por Operador
	
	If A110Perfil() .And. A110Param()
		IF lAcessoLck
			
			//Valida acessos disponiveis usando o Semaforo
			lContinua := LockByName("csfa110" + __cUserID + StrZero(1,2,0),.f.,.f.,.t.)
			
			If lContinua
				If cU7_TIPO=='2'
					cRet := A110SelOpe()
					If !Empty( cRet )
						cU7_OPERAD := "IN "+cRet+" "
					Endif
				Else
					cU7_OPERAD := "= '"+cU7_COD+"' "
				Endif
				If !Empty( cU7_OPERAD )
					If A110SelAge()
						A110Agenda()
					Endif
				Endif
				//Libera o Uso
				UnlockByName("csfa110" + __cUserID + StrZero(1,2,0),.f.,.f.,.t.)
			Else
				MsgAlert('Esta rotina já está sendo executada pelo usuário '+RTrim(cUserName)+'. Feche uma das seções e execute somente uma.',cCadastro)
			Endif
			FClose(nHandle)
			FErase(cArqLck)
		Else
			cMvAgOp += cU7_COD
			__cMvAgOp := cMvAgOp 
			IF .NOT. Empty( GetMv( cMvAgOp, .F. ) )
				lContinua := .F.
			EndIF
								
			If lContinua
				PutMv(cMvAgOp,'#@#')
				If cU7_TIPO=='2'
					cRet := A110SelOpe()
					If !Empty( cRet )
						cU7_OPERAD := "IN "+cRet+" "
					Endif
				Else
					cU7_OPERAD := "= '"+cU7_COD+"' "
				Endif
				If !Empty( cU7_OPERAD )
					If A110SelAge()
						A110Agenda()
					Endif
				Endif
				PutMv(cMvAgOp,' ')
			Else
				MsgAlert('Esta rotina já está sendo executada pelo usuário '+RTrim(cUserName)+'. Feche uma das seções e execute somente uma.',cCadastro)
			Endif
		EndIF
	Endif
		
Return

//-----------------------------------------------------------------------
// Rotina | A110Perfil | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar o perfil do usuário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Perfil()
	Local lRet		:= .F.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserID ) )
		lRet       := .T.
		cU7_COD    := SU7->U7_COD
		cU7_NOME   := RTrim( SU7->U7_NOME )
		cU7_TIPO   := SU7->U7_TIPO
		cU7_CODVEN := SU7->U7_CODVEN
		
		cA3_XCANAL := Posicione('SA3',1,xFilial('SA3')+SU7->U7_CODVEN,'A3_XCANAL')
		
	Else
		MsgInfo( 'Usuário não está cadastrado como operador, por favor, verifique.', cCadastro )
	Endif	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A110SelOpe | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/selecionar operadores e visualizar sua agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SelOpe()
	Local oDlg
	Local oLbx
	Local oPnlTop
	Local oPnlBot
	
	Local nI        := 0
	Local nL        := 2
	Local nOpc      := 0
	Local nSelect   := 0
	Local nOperad   := 0
	Local nSair     := 1
	
	Local cRet      := ''
	Local cSQL      := ''
	Local cTRB      := ''
	Local cMsg      := 'É necessário selecionar algum operador antes de concluir.'
	Local cTotal    := ''
	
	Local aButton   := {}
	
	Local lDados    := (Len(aDadosOp)>0)
	Local lMrkAll   := .F.
	Local oMrkAll   := NIL
	
	Local oMrk      := LoadBitmap( GetResources(), "LBOK" )
	Local oNoMrk    := LoadBitmap( GetResources(), "LBNO" )
	
	Local	cCbxPesq := ''
	Local oCbxPesq  := NIL
	Local	aCbxPesq := {}
	Local nCbxPesq  := 1			
	Local cGetPesq  := Space(50)
	Local oGetPesq  := NIL			
	Local oBtnPesq  := NIL
	Local oCbxIndex 
	Local cCbxIndex := ''
	Local aCbxIndex := {'Data e hora + Operador','Operador + Data e hora'}
	Local nCbxIndex := 1			
	
	Local oSelect
	Local oOperad

	Local aPar      := {}
	Local aRet      := {}
	Local aCanal    := {Replicate("#",Len(SZ2->Z2_CODIGO))}

	If !lDados
		SetKey( VK_F11 , {|| A110ChgSX6() } )
		SetKey( VK_F12 , {|| lReportQry := MsgYesNo('Exportar a string das querys?',cCadastro ) } )
		
		FormBatch( cCadastro, {'Você supervisor iniciará a Agenda do Operador Certisign, porém é preciso que você',;
		                       'selecione o código do canal de vendas e logo os operadores/consultores que desejar.',;
		                       ' ','Clique em OK para prosseguir...'},;
		                       {{01, .T., { || nSair := 0, FechaBatch() } },;
		                       {22, .T., { || FechaBatch() } } } )
		
		SetKey( VK_F11 , {|| .T. })
		SetKey( VK_F12 , {|| .T. })
		
	   If nSair == 0
			If ParamBox(;
				{{1,'Código do canal de vendas',Space(Len(SZ2->Z2_CODIGO)),'@!',"ExistCpo('SZ2')",'SZ2','',50,.T.}},;
				'Informe o canal de vendas',@aCanal,,,,,,,,.F.,.F.)
				
				cA3_XCANAL := aCanal[1]
				
				cSQL := "SELECT U7_NOME, "														+ CRLF
				cSQL += "       U7_COD, "														+ CRLF
				cSQL += "       U7_CODVEN, "													+ CRLF
				cSQL += "       A3_CODUSR, "													+ CRLF
				cSQL += "       U7_NREDUZ "														+ CRLF
				cSQL += "FROM   "+RetSqlName("SU7")+" SU7 "									+ CRLF
				cSQL += "       INNER JOIN "+RetSqlName("SA3")+" SA3 "						+ CRLF
				cSQL += "               ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " 	+ CRLF
				cSQL += "                  AND A3_COD = U7_CODVEN "							+ CRLF
				cSQL += "                  AND A3_XCANAL = "+ValToSql( cA3_XCANAL )+" " 	+ CRLF
				cSQL += "                  AND A3_MSBLQL <> '1' "							+ CRLF
				cSQL += "                  AND SA3.D_E_L_E_T_ = ' ' "						+ CRLF
				cSQL += "WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7"))+" "					+ CRLF
				cSQL += "       AND SU7.U7_VALIDO <> '2' "									+ CRLF
				cSQL += "       AND SU7.D_E_L_E_T_ = ' ' "									+ CRLF
				cSQL += "ORDER  BY U7_NOME "													+ CRLF
			
				cTRB := GetNextAlias()
				cSQL := ChangeQuery( cSQL )
				MsgRun("Buscando operadores, agurade...",cCadastro,{|| PLSQuery( cSQL, cTRB ) })
				If (cTRB)->( BOF() .And. EOF() )
					MsgInfo('Não foi possível encontrar registros de operadores.', cCadastro)
				Else
					While ! (cTRB)->( EOF() )
						(cTRB)->( AAdd( aDadosOp, { .F., U7_NOME, U7_COD, U7_CODVEN, A3_CODUSR, U7_NREDUZ,'' } ) )
						(cTRB)->( dbSkip() )
					End
					(cTRB)->(dbCloseArea())
					lDados := (Len(aDadosOp)>0)
				Endif
			Endif
		Endif
	Endif
	
	If lDados		
		AAdd( aButton, { '&Concluído','{|| '+;
		'Iif((AScan(aDadosOp,{|p| p[1]==.T.})>0),'+;
		'Iif(MsgYesNo("Confirma a conclusão da seleção de operadores?",cCadastro),'+;
		'(nOpc:=1,oDlg:End()),NIL),MsgInfo(cMsg,cCadastro))  }' } )
		
		AAdd( aButton, { '&Abandonar','{|| oDlg:End() }' } )
		
		AEval(aDadosOp,{|p| nSelect+=Iif(p[1],1,0)})
		nOperad := Len(aDadosOp)

		DEFINE MSDIALOG oDlg TITLE 'Seleção de Operadores' FROM 0,0 TO 308,715 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
			oDlg:lEscClose := .F.
			
			oPnlLbx := TPanel():New(0,0,'',oDlg,,.T.,,,,40,0,.T.,.F.)
			oPnlLbx:Align := CONTROL_ALIGN_ALLCLIENT
			
			oPnlAcao := TPanel():New(0,0,'',oDlg,,.T.,,,RGB(240,240,240),82,0,.T.,.F.)
			oPnlAcao:Align := CONTROL_ALIGN_RIGHT
			
			oPnlTop := TPanel():New(0,0,'',oPnlLbx,,.T.,,,,40,15,.T.,.F.)
			oPnlTop:Align := CONTROL_ALIGN_TOP
			
			oPnlBott := TPanel():New(0,0,'',oPnlAcao,,.T.,,,,40,14,.T.,.F.)
			oPnlBott:Align := CONTROL_ALIGN_BOTTOM

		   oLbx := TwBrowse():New(0,0,1000,1000,,{'','Nome Operador','Código','Vendedor','Código de usuário','Nome usuário',''},,oPnlLbx,,,,,,,,,,,,.F.,,.T.,,.F.)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDadosOp )
		   oLbx:bLDblClick := {|| aDadosOp[oLbx:nAt,1]:=!aDadosOp[oLbx:nAt,1],;
		   (nSelect:=0,AEval(aDadosOp,{|p| nSelect+=Iif(p[1],1,0)}),oSelect:SetText(LTrim(Str(nSelect))))}
		   
			oLbx:bLine := {|| {Iif(aDadosOp[oLbx:nAt,1],oMrk,oNoMrk),aDadosOp[oLbx:nAt,2],aDadosOp[oLbx:nAt,3],;
			aDadosOp[oLbx:nAt,4],aDadosOp[oLbx:nAt,5],aDadosOp[oLbx:nAt,6],aDadosOp[oLbx:nAt,7]}}
			oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMrkAll := !lMrkAll, oMrkAll:Refresh(),;
			                     AEval( aDadosOp, {|p| p[1] := lMrkAll } ),oLbx:Refresh(),;
			                     (nSelect:=0,AEval(aDadosOp,{|p| nSelect+=Iif(p[1],1,0)}),oSelect:SetText(LTrim(Str(nSelect))))}
			
			For nI := 1 To Len( aButton )			
				TButton():New(3,nL,aButton[nI,1],oPnlBott,&(aButton[nI,2]),38,10,,,.F.,.T.,.F.,,.F.,,,.F.)
				nL += 40
			Next nI

			AAdd( aCbxPesq, 'Nome do operador' )
			AAdd( aCbxPesq, 'Código do operador' )
			
			@ 2,001 COMBOBOX oCbxPesq VAR cCbxPesq ITEMS aCbxPesq SIZE 70,20 PIXEL OF oPnlTop ON CHANGE (nCbxPesq:=oCbxPesq:nAt)
			@ 2,73 MSGET oGetPesq VAR cGetPesq Size 96,9 PIXEL OF oPnlTop
			@ 2,171 BUTTON oBtnPesq PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPnlTop ACTION (A110PesqOp(@oLbx,nCbxPesq,cGetPesq))		
			
			@ 2,2 SAY 'Operadores selecionados:' OF oPnlAcao PIXEL COLOR CLR_BLUE SIZE 100,10
			@ 10,2 SAY 'Total de operadores:'     OF oPnlAcao PIXEL COLOR CLR_BLUE SIZE 100,10
			
			@ 2,72 SAY oSelect PROMPT LTrim(Str(nSelect)) OF oPnlAcao PIXEL COLOR CLR_BLUE SIZE 100,10
			@ 10,72 SAY oOperad PROMPT LTrim(Str(nOperad)) OF oPnlAcao PIXEL COLOR CLR_BLUE SIZE 100,10
			
			@ 22,2 CHECKBOX oMrkAll VAR lMrkAll PROMPT "Selecionar todos registros?" SIZE 100,7 PIXEL OF oPnlAcao COLOR CLR_BLUE ;
         ON CLICK( AEval( aDadosOp, {|p| p[1] := lMrkAll } ),oLbx:Refresh(),;
         (nSelect:=0,AEval(aDadosOp,{|p| nSelect+=Iif(p[1],1,0)}),oSelect:SetText(LTrim(Str(nSelect)))))
         
			@ 34,2 SAY 'Visualizar agenda na ordem?' OF oPnlAcao PIXEL COLOR CLR_BLUE SIZE 100,10
			@ 42,2 COMBOBOX oCbxIndex VAR cCbxIndex ITEMS aCbxIndex SIZE 78,20 PIXEL OF oPnlAcao ON CHANGE (nCbxIndex:=oCbxIndex:nAt,nOrdemQry:=nCbxIndex)
		ACTIVATE MSDIALOG oDlg CENTER		
			
		If nOpc == 1
			If lReportQry
				A110Script( cSQL )
			Endif
			A110Contem(@cRet)
		Endif
	Endif
Return(cRet)

//-----------------------------------------------------------------------
// Rotina | A110SelOrd | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina solicitar a ordem de apresentação das agendas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SelOrd()
	Local aPar := {}
	Local aRet := {}
	Local lRet := .T.
	AAdd(aPar,{3,"Selecione a ordem das agendas",1,{"Data da agenda e hora + Operador","Operador + Data da agenda e hora"},99,"",.T.})
	lRet := ParamBox(aPar,"Ordem para apresentar as agendas",@aRet)
	If lRet 
		nOrdemQry := aRet[1]
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Contem | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a expressão contém para SQL.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Contem(cRet)
	Local nI := 0
	cRet := "('"
	For nI := 1 To Len( aDadosOp )
		If aDadosOp[nI,1]
			cRet += aDadosOp[nI,3] + "','"
		Endif
	Next nI
	cRet := SubStr(cRet,1,Len(cRet)-2)+")"
Return

//-----------------------------------------------------------------------
// Rotina | A110PesqOp | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar operador no ListBox.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110PesqOp(oLbx,nCbx,cPesq)
	Local nP := 0
	Local nCol := Iif(nCbx==1,2,Iif(nCbx==2,3,0))
	If nCol > 0
		cPesq := Upper( AllTrim( cPesq ) )
		nP := AScan( aDadosOp, {|p| cPesq $ Upper( AllTrim( p[ nCol ] ) ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			MsgAlert('Não foi possível encontrar o registro.',cCadastro)
		Endif
	Else
		MsgAlert('Opção de pesquisa inválida.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110SelAge | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que comandará a elaboração dos campos,aHeaders e aCOLS
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SelAge()
	Local cTRB   := ''
	Local nCount := 0

	nCount := A110Lista(@cTRB)
	
	If nCount > 0
		A110Head()
		A110Cols(cTRB)
		(cTRB)->(dbCloseArea())
	Endif
Return(nCount>0)

//-----------------------------------------------------------------------
// Rotina | A110Lista  | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que executa a query para buscar a lista de contatos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Lista( cTRB, nFilAgenda, nFilEntida, dExpirDe, dExpirAte, cContato, cEmpresa, nNomLista, cContem, nPriori )
	Local cSQL        := ''
	Local nCount      := 1
	Local dMV_DTAGEND := 'MV_DTAGEND'
	
	DEFAULT nFilAgenda := 0
	DEFAULT nFilEntida := 0
	DEFAULT dExpirDe   := Ctod( Space( 8 ) )
	DEFAULT dExpirAte  := Ctod( Space( 8 ) )
	DEFAULT cContato   := ''
	DEFAULT cEmpresa   := ''
	DEFAULT nNomLista  := 0
	DEFAULT cContem    := ''
	DEFAULT nPriori    := 1
	
	If .NOT. SX6->( ExisteSX6( dMV_DTAGEND ) )
		CriarSX6( dMV_DTAGEND, 'D', 'A PARTIR DE QUE DATA A QUERY DEVE BUSCAR REGISTRO DA LISTA DE CONTATO (SU4/SU6). BRANCO CONSIDERA-SE TODOS. CSFA110.prw', '' )
	Endif
	dMV_DTAGEND := GetMv( dMV_DTAGEND )

	cSQL := ''
	If .NOT. Empty( cEmpresa )
		cSQL += "SELECT U4_DATA, " + CRLF
		cSQL += "       U4_HORA1, " + CRLF
		cSQL += "       U4_XPRIOR, " + CRLF
		cSQL += "       U4_LISTA, " + CRLF
		cSQL += "       U4_STATUS, " + CRLF
		cSQL += "       U4_DESC, " + CRLF
		cSQL += "       U4_DTEXPIR, " + CRLF
		cSQL += "       U4_CODLIG, " + CRLF
		cSQL += "       U6_ATENDIM, " + CRLF
		cSQL += "       U6_CODIGO, " + CRLF
		cSQL += "       U6_CONTATO, " + CRLF
		cSQL += "       U5_CONTAT, " + CRLF
		cSQL += "       U6_ENTIDA, " + CRLF
		cSQL += "       U6_CODENT, " + CRLF
		cSQL += "       U6_STATUS, " + CRLF
		cSQL += "       U4_RECNO, " + CRLF
		cSQL += "       U5_RECNO, " + CRLF
		cSQL += "       U6_RECNO, " + CRLF
		cSQL += "       U6_DENTIDA," + CRLF
		cSQL += "       GD_LEGENDA," + CRLF
		cSQL += "       U6_DESCENT" + CRLF
		cSQL += "FROM   ( " + CRLF
	Endif
	cSQL += "SELECT U4_DATA, " + CRLF
	cSQL += "       U4_HORA1, " + CRLF
	cSQL += "       U4_XPRIOR, " + CRLF
	cSQL += "       U4_LISTA, " + CRLF
	cSQL += "       U4_STATUS, " + CRLF
	cSQL += "       U4_DESC, " + CRLF
	cSQL += "       U4_DTEXPIR, " + CRLF
	cSQL += "       U4_CODLIG, " + CRLF
	cSQL += "       U6_ATENDIM, " + CRLF
	cSQL += "       U6_CODIGO, " + CRLF
	cSQL += "       U6_CONTATO, " + CRLF
	cSQL += "       U5_CONTAT, " + CRLF
	cSQL += "       U6_ENTIDA, " + CRLF
	cSQL += "       RTrim(U6_CODENT) AS U6_CODENT, " + CRLF
	cSQL += "       U6_STATUS, " + CRLF
	cSQL += "       SU4.R_E_C_N_O_ AS U4_RECNO, " + CRLF
	cSQL += "       SU5.R_E_C_N_O_ AS U5_RECNO, " + CRLF
	cSQL += "       SU6.R_E_C_N_O_ AS U6_RECNO, " + CRLF
	// Se for supervisor apresentar as colunas.
	If cU7_TIPO=='2'
		cSQL += "       SU4.U4_OPERAD," + CRLF
		cSQL += "       SU7.U7_NOME," + CRLF
	Endif
	cSQL += "       CASE " + CRLF
	cSQL += "		   WHEN U6_ENTIDA = 'SZT' THEN 'SSL RENOV. COMMON NAME' " + CRLF
	cSQL += "	      WHEN U6_ENTIDA = 'SZX' THEN 'ICP-BRASIL' " + CRLF
	cSQL += "	      WHEN U6_ENTIDA = 'PAB' THEN 'LISTAS DE CONTATOS' " + CRLF
	cSQL += "	      WHEN U6_ENTIDA = 'SA1' THEN 'CLIENTES' " + CRLF
	cSQL += "	      WHEN U6_ENTIDA = 'SUS' THEN 'PROSPECTS' " + CRLF
	cSQL += "	      WHEN U6_ENTIDA = 'ACH' THEN 'SUSPECTS' " + CRLF
	cSQL += "       END AS U6_DENTIDA, " + CRLF
	cSQL += "       CASE " + CRLF
	cSQL += "         WHEN U4_CODLIG =  "+ValToSql(Space(Len(SU4->U4_CODLIG)))+" THEN "+ValToSql(NAO_E_RETORNO)+" " + CRLF
	cSQL += "         WHEN U4_CODLIG <> "+ValToSql(Space(Len(SU4->U4_CODLIG)))+" THEN "+ValToSql(SIM_E_RETORNO)+" " + CRLF
	cSQL += "       END AS GD_LEGENDA, " + CRLF
	// Início do CASE
	cSQL += "       CASE " + CRLF
	// 1º Case
	cSQL += "		   WHEN U6_ENTIDA = 'SZT' THEN ( SELECT ZT_EMPRESA " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                       WHERE  ZT_FILIAL  = "+ValToSql(xFilial("SZT"))+" " + CRLF
	cSQL += "                                              AND ZT_CODIGO = SubStr(U6_CODENT,1,6) " + CRLF
	cSQL += "                                              AND SZT.D_E_L_E_T_ = ' '  and rownum = 1) " + CRLF
	// 2º Case
	cSQL += "	      WHEN U6_ENTIDA = 'SZX' THEN ( SELECT ZX_DSRAZAO " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("SZX")+" SZX " + CRLF
	cSQL += "                                       WHERE  ZX_FILIAL  = "+ValToSql(xFilial("SZX"))+" " + CRLF
	cSQL += "                                              AND ZX_CODIGO = SubStr(U6_CODENT,1,6) " + CRLF
	cSQL += "                                              AND SZX.D_E_L_E_T_ = ' '   and rownum = 1) " + CRLF
	// 3º Case
	cSQL += "	      WHEN U6_ENTIDA = 'SA1' THEN ( SELECT A1_NOME " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("SA1")+" SA1 " + CRLF
	cSQL += "                                       WHERE  A1_FILIAL  = "+ValToSql(xFilial("SA1"))+" " + CRLF
	cSQL += "                                              AND A1_COD = SubStr(U6_CODENT,1,6) " + CRLF
	cSQL += "                                              AND SA1.D_E_L_E_T_ = ' ' and rownum = 1) " + CRLF
	// 4º Case
	cSQL += "	      WHEN U6_ENTIDA = 'PAB' THEN ( SELECT PAB_NOME " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("PAB")+" PAB " + CRLF
	cSQL += "                                       WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+" " + CRLF
	cSQL += "                                              AND PAB_CODIGO = SubStr(U6_CODENT,1,6) " + CRLF
	cSQL += "                                              AND PAB.D_E_L_E_T_ = ' ' and rownum = 1) " + CRLF
	// 5º Case
	cSQL += "	      WHEN U6_ENTIDA = 'SUS' THEN ( SELECT US_NOME " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("SUS")+" SUS " + CRLF
	cSQL += "                                       WHERE  US_FILIAL  = "+ValToSql(xFilial("SUS"))+" " + CRLF
	cSQL += "                                              AND US_COD = SubStr(U6_CODENT,1,6)  " + CRLF
	cSQL += "                                              AND SUS.D_E_L_E_T_ = ' ' and rownum = 1) " + CRLF
	// 6º Case
	cSQL += "	      WHEN U6_ENTIDA = 'ACH' THEN ( SELECT ACH_RAZAO " + CRLF
	cSQL += "                                       FROM   "+RetSqlName("ACH")+" ACH " + CRLF
	cSQL += "                                       WHERE  ACH_FILIAL = "+ValToSql(xFilial("ACH"))+" " + CRLF
	cSQL += "                                              AND ACH_CODIGO = SubStr(U6_CODENT,1,6) " + CRLF
	cSQL += "                                              AND ACH.D_E_L_E_T_ = ' ' and rownum = 1) " + CRLF
	// Fim do CASE
	cSQL += "       END AS U6_DESCENT " + CRLF
	cSQL += "FROM   "+RetSqlName("SU4")+" SU4 "  + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SU6")+" SU6 " + CRLF
	cSQL += "               ON U6_FILIAL = "+ValToSql(xFilial("SU6"))+" " + CRLF
	cSQL += "                  AND U6_LISTA = U4_LISTA " + CRLF
	cSQL += "                  AND SU6.D_E_L_E_T_ = ' ' "  + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SU5")+" SU5 " + CRLF
	cSQL += "               ON U5_FILIAL = "+ValToSql(xFilial("SU5"))+" " + CRLF
	cSQL += "                  AND U5_CODCONT = U6_CONTATO " + CRLF
	cSQL += "                  AND SU5.D_E_L_E_T_ = ' ' " + CRLF
	// Apresentar as agendas dos operadores selecionados
	If cU7_TIPO=='2'
		cSQL += "       INNER JOIN "+RetSqlName("SU7")+" SU7 " + CRLF
		cSQL += "               ON U7_FILIAL = "+ValToSql(xFilial("SU7"))+" " + CRLF
		cSQL += "                  AND U7_COD = U4_OPERAD " + CRLF
		cSQL += "                  AND SU7.D_E_L_E_T_ = ' ' " + CRLF
	Endif
	cSQL += "WHERE  U4_FILIAL = "+ValToSql(xFilial("SU4"))+" " + CRLF
	cSQL += "       AND SU4.D_E_L_E_T_ = ' '" + CRLF
	// Apresentar as agendas a partir de qual data, caso haja data gravada no parâmetro.
	If .NOT. Empty( dMV_DTAGEND )
		cSQL += "       AND SU4.U4_DATA > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif
	cSQL += "       AND U4_OPERAD "+cU7_OPERAD+" " + CRLF
	cSQL += "       AND U4_TELE = '1' " + CRLF
	cSQL += "       AND ( U4_FORMA = '1' " + CRLF
	cSQL += "              OR U4_FORMA = '5' " + CRLF
	cSQL += "              OR U4_FORMA = '6' ) " + CRLF
	// Filtrar quais agendas.
	If nFilAgenda > 1
		// Sem retorno de agenda.
		If nFilAgenda == 2
			cSQL += "       AND U4_CODLIG = '"+Space(Len(SU4->U4_CODLIG))+"' " + CRLF
		// Com retorno de agenda.
		Elseif nFilAgenda == 3
			cSQL += "       AND U4_CODLIG <> '"+Space(Len(SU4->U4_CODLIG))+"' " + CRLF
		Endif
	Endif
	// Filtrar entidades.
	If nFilEntida > 1
		If nFilEntida == 2
			// Renovação SSL.
			cSQL += "       AND U6_ENTIDA = 'SZT' " + CRLF
		Elseif nFilEntida == 3
			// Renovação ICP.
			cSQL += "       AND U6_ENTIDA = 'SZX' " + CRLF
		Elseif nFilEntida == 4
			// Renovação Importação de listas.
			cSQL += "       AND U6_ENTIDA = 'PAB' " + CRLF
		Elseif nFilEntida == 5
			// Clientes.
			cSQL += "       AND U6_ENTIDA = 'SA1' " + CRLF
		Elseif nFilEntida == 6
			// Prospects.
			cSQL += "       AND U6_ENTIDA = 'SUS' " + CRLF
		Elseif nFilEntida == 7
			// Suspects.
			cSQL += "       AND U6_ENTIDA = 'ACH' " + CRLF
		Endif
	Endif
	//Filtrar Nome da Lista
	If nNomLista > 1
		If nNomLista == 2
			// Renovação.
			cSQL += "       AND UPPER(U4_DESC) LIKE '%RENOV%' " + CRLF
		Elseif nNomLista == 3
			// Renovação ICP.
			cSQL += "       AND UPPER(U4_DESC) LIKE '%ATIVACAO%' " + CRLF
		Elseif nNomLista == 4
			// Renovação Importação de listas.
			cSQL += "       AND UPPER(U4_DESC) LIKE '%"+ AllTrim(cContem) +"%' " + CRLF
		Endif
	EndIf
	
	//Filtrar a Prioridade do Atendimento
	If nPriori > 1
		If nPriori == 2
			// Renovação.
			cSQL += "       AND U4_XPRIOR = '1' " + CRLF
		Elseif nPriori == 3
			// Renovação Importação de listas.
			cSQL += "       AND U4_XPRIOR = '2' " + CRLF
		Endif
	EndIf
	
	// Filtrar por data de expiração.
	If .NOT.Empty( dExpirDe ) .And. .NOT.Empty( dExpirAte )
		cSQL += "       AND U4_DTEXPIR >= "+ValtoSql( dExpirDe )+" AND U4_DTEXPIR <= "+ValToSql( dExpirAte )+" " + CRLF
	Endif
	// Filtrar por nome de contato.
	If .NOT.Empty( cContato )
		cSQL += "       AND U5_CONTAT LIKE '%"+cContato+"%' " + CRLF
	Endif
	// Selecionar a ordem de apresentação dos dados na agenda.
	If nOrdemQry == 1
		cSQL += "ORDER  BY U4_DATA, U4_HORA1, "+Iif(cU7_TIPO=='2','U4_OPERAD,','')+" U4_STATUS " + CRLF
	Elseif nOrdemQry == 2
		cSQL += "ORDER  BY "+Iif(cU7_TIPO=='2','U4_OPERAD, ','')+"U4_DATA, U4_HORA1, U4_STATUS " + CRLF
	Endif	
	// Filtrar empresa.
	If .NOT. Empty( cEmpresa )
		cSQL += ") "+GetNextAlias()+" " + CRLF
		cSQL += "WHERE U6_DESCENT LIKE '%"+cEmpresa+"%' " + CRLF
	Endif	
	
	If lReportQry
		A110Script( cSQL )
	Endif
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando as agendas...')
	If (cTRB)->( BOF() .And. EOF() )
		nCount := 0
		MsgInfo('Não há dados de agenda para ser apresentado.',cCadastro)
	Endif
Return( nCount )

//-----------------------------------------------------------------------
// Rotina | A110Head   | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que monta os aHeadres.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
 Static Function A110Head()
	Local nI := 0
	
	aCpoGd := {}
	
 	//-------------------------------
 	// Coluna de legenda da getdados.
 	//-------------------------------
 	AAdd( aHeader1, { '', 'GD_LEGENDA', '@BMP', 10, 0, '', '', 'C', '', 'V' } )
 	AAdd( aHeader2, { '', 'GD_LEGENDA', '@BMP', 10, 0, '', '', 'C', '', 'V' } )
 	AAdd( aHeader3, { '', 'GD_LEGENDA', '@BMP', 10, 0, '', '', 'C', '', 'V' } )

	//---------------------------------------------
	// Somente o supervisor enxergará estes campos.
	//---------------------------------------------
	If cU7_TIPO=='2'
		AAdd( aCpoGd, {'U4_OPERAD','Operador'} )
		AAdd( aCpoGd, {'U7_NOME'  ,'Nome do operador'} )
	Endif
	
	//------------------------------------------------
	// Campos visual para todos os perfis de usuários.
	//------------------------------------------------
	AAdd( aCpoGd, {'U4_XPRIOR' ,'Prioridade'} )
	AAdd( aCpoGd, {'U4_DATA'   ,'DT.Agenda' } )
	AAdd( aCpoGd, {'U4_HORA1'  ,'HR.Agenda' } )

	AAdd( aCpoGd, {'U4_DESC'   ,'Nome da lista'    } )
	AAdd( aCpoGd, {'U4_DTEXPIR','DT.Expira'        } )
	AAdd( aCpoGd, {'U5_CONTAT' ,'Nome do contato'  } )
	AAdd( aCpoGd, {'U6_DESCENT','Nome da entidade' } )
	
	AAdd( aCpoGd, {'U4_LISTA'  ,'Lista'              } )
	AAdd( aCpoGd, {'U6_CODIGO' ,'Sequencia'          } )
	AAdd( aCpoGd, {'U6_CONTATO','Contato'            } )
	AAdd( aCpoGd, {'U6_CODENT' ,'Entidade'           } )
	AAdd( aCpoGd, {'U6_ENTIDA' ,'Sigla'              } )
	AAdd( aCpoGd, {'U6_DENTIDA','Descrição da sigla' } )
	AAdd( aCpoGd, {'U4_CODLIG' ,'Retorno'            } )
	AAdd( aCpoGd, {'U6_ATENDIM','Atendimento'        } )
	
	AAdd( aCpoGd, {'U4_STATUS' ,'Fase SU4'} )
	AAdd( aCpoGd, {'U6_STATUS' ,'Fase SU6'} )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpoGd )
		SX3->( dbSeek( aCpoGd[ nI, 1 ] ) )
		SX3->( AAdd( aHeader1, { aCpoGd[ nI, 2], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		SX3->( AAdd( aHeader2, { aCpoGd[ nI, 2], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		SX3->( AAdd( aHeader3, { aCpoGd[ nI, 2], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
	Next nI

	AAdd( aHeader1, { 'Recno(SU4)', 'U4_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader1, { 'Recno(SU5)', 'U5_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader1, { 'Recno(SU6)', 'U6_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader1, { 'Item'      , 'GD_ITEM'  , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader1, { 'Global'    , 'GD_GLOBAL', '@!',150, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
			
	AAdd( aHeader2, { 'Recno(SU4)', 'U4_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader2, { 'Recno(SU5)', 'U5_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader2, { 'Recno(SU6)', 'U6_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader2, { 'Item'      , 'GD_ITEM'  , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader2, { 'Global'    , 'GD_GLOBAL', '@!',150, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	
	AAdd( aHeader3, { 'Recno(SU4)', 'U4_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader3, { 'Recno(SU5)', 'U5_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader3, { 'Recno(SU6)', 'U6_RECNO' , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader3, { 'Item'      , 'GD_ITEM'  , '@!', 10, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
	AAdd( aHeader3, { 'Global'    , 'GD_GLOBAL', '@!',150, 0, 'AllWaysTrue', '', 'N', '', 'V'} )
Return

//-----------------------------------------------------------------------
// Rotina | A110Cols   | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que monta os aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Cols( cTRB )
	Local nI         := 0
	Local nElem1     := 0
	Local nElem2     := 0
	Local nElem3     := 0
	Local nGD_ITEM   := 0
	Local nGD_GLOBAL := 0
	Local cNoFields  := ''
	
	cNoFields  := 'GD_ITEM|GD_LEGENDA|GD_GLOBAL'
	nGD_ITEM   := AScan( aHeader1,{|p| p[2]=='GD_ITEM'})
	nGD_GLOBAL := AScan( aHeader1,{|p| p[2]=='GD_GLOBAL'})

	While !(cTRB)->(EOF())
		// Agenda em dia ou atrasada.
		If (cTRB)->U4_DATA <= MsDate() .And. (cTRB)->U4_STATUS == '1' .And. (cTRB)->U6_STATUS == '1'
			AAdd( aCOLS1, Array( Len( aHeader1 ) + 1 ) )
			nElem1 := Len( aCOLS1 )
			For nI := 1 To Len( aHeader1 )
				//-- David.Santos
				If nI == nGD_ITEM .Or. nI == nGD_GLOBAL
					Loop
				EndIf
				If aHeader1[ nI, 2 ]=='U6_ATENDIM'
					nPara := 0 //RLEG
				Endif
				aCOLS1[ nElem1, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader1[ nI, 2 ] ) ) )
			Next nI                                     
			aCOLS1[ nElem1, nGD_ITEM ] := nElem1
			aCOLS1[ nElem1, nGD_GLOBAL ] := (cTRB)->( RTrim(U4_DESC) + RTrim(U5_CONTAT) + RTrim(U6_DESCENT) + RTrim(U6_DENTIDA) )
			aCOLS1[ nElem1, Len( aHeader1 ) + 1 ] := .F.
		// Agenda para atender.
		Elseif (cTRB)->U4_DATA >  MsDate() .And. (cTRB)->U4_STATUS == '1' .And. (cTRB)->U6_STATUS == '1'
			AAdd( aCOLS3, Array( Len( aHeader3 ) + 1 ) )
			nElem3 := Len( aCOLS3 )
			For nI := 1 To Len( aHeader3 )
				//-- David.Santos
				If nI == nGD_ITEM .Or. nI == nGD_GLOBAL
					Loop
				EndIf
				aCOLS3[ nElem3, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader3[ nI, 2 ] ) ) )
			Next nI
			aCOLS3[ nElem3, nGD_ITEM ] := nElem3
			aCOLS3[ nElem3, nGD_GLOBAL ] := (cTRB)->( RTrim(U4_DESC) + RTrim(U5_CONTAT) + RTrim(U6_DESCENT) + RTrim(U6_DENTIDA) )
			aCOLS3[ nElem3, Len( aHeader3 ) + 1 ] := .F.
		// Agenda atendida.
		Else
			AAdd( aCOLS2, Array( Len( aHeader2 ) + 1 ) )
			nElem2 := Len( aCOLS2 )
			For nI := 1 To Len( aHeader2 )
				//-- David.Santos
				If nI == nGD_ITEM .Or. nI == nGD_GLOBAL
					Loop
				EndIf
				aCOLS2[ nElem2, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader2[ nI, 2 ] ) ) )
			Next nI
			aCOLS2[ nElem2, nGD_ITEM ] := nElem2
			aCOLS2[ nElem2, nGD_GLOBAL ] := (cTRB)->( RTrim(U4_DESC) + RTrim(U5_CONTAT) + RTrim(U6_DESCENT) + RTrim(U6_DENTIDA) )
			aCOLS2[ nElem2, Len( aHeader2 ) + 1 ] := .F.
		Endif 
		(cTRB)->(dbSkip())
	End
	//----------------------------------------------------------
	// Caso o aCOLS esteja vazio, atribuir uma linha vazia nele.
	//----------------------------------------------------------
	If Len(aCOLS1)==0
		AAdd( aCOLS1, Array( Len( aHeader1 ) + 1 ) )
		For nI := 1 To Len( aHeader1 )
			If 'RECNO' $ aHeader1[nI,2]
				aCOLS1[1,nI] := 0
			Else
				If !(aHeader1[nI,2] $ cNoFields)
					aCOLS1[1,nI] := CriaVar(aHeader1[nI,2],.F.)
				Endif
			Endif
		Next nI
		aCOLS1[ 1, Len( aHeader1 ) + 1 ] := .F.
	Endif
	//----------------------------------------------------------
	// Caso o aCOLS esteja vazio, atribuir uma linha vazia nele.
	//----------------------------------------------------------
	If Len(aCOLS2)==0
		AAdd( aCOLS2, Array( Len( aHeader2 ) + 1 ) )
		For nI := 1 To Len( aHeader2 )
			If 'RECNO' $ aHeader2[nI,2]
				aCOLS2[1,nI] := 0
			Else
				If !(aHeader2[nI,2] $ cNoFields)
					aCOLS2[1,nI] := CriaVar(aHeader2[nI,2],.F.)
				Endif
			Endif
		Next nI
		aCOLS2[ 1, Len( aHeader2 ) + 1 ] := .F.
	Endif
	//----------------------------------------------------------
	// Caso o aCOLS esteja vazio, atribuir uma linha vazia nele.
	//----------------------------------------------------------
	If Len(aCOLS3)==0
		AAdd( aCOLS3, Array( Len( aHeader3 ) + 1 ) )
		For nI := 1 To Len( aHeader3 )
			If 'RECNO' $ aHeader3[nI,2]
				aCOLS3[1,nI] := 0
			Else
				If !(aHeader3[nI,2] $ cNoFields)
					aCOLS3[1,nI] := CriaVar(aHeader3[nI,2],.F.)
				Endif
			Endif
		Next nI
		aCOLS3[ 1, Len( aHeader3 ) + 1 ] := .F.
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110Agenda | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados da agenda do(s) operador(es).
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Agenda()
	Local nLargura  := 0
	Local nAltura   := 0
	Local nMeio     := 0
	Local nOpc      := 0
	Local nI        := 0
	Local nP        := 0
	Local nG        := 0
	Local nObj      := 0
		
	Local oDlg 
	Local oPnlLeft
	Local oPnlRest
	Local oPF1Left, oPF2Left, oPF3Left
	Local oPF1Rest, oPF2Rest, oPF3Rest
	Local oPF1RTop, oPF2RTop, oPF3RTop
	Local oPF1RBottom, oPF2RBottom, oPF3RBottom
	
	Local oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oBtn6, oBtn7, oBtn8, oBtn9, oBtnA1, oBtnB1,oBtnC1,oBtnD1,oBtnE1,oBtnF1
	Local oBtn41, oBtn51, oBtn61, oBtn71, oBtn81, oBtn91
	Local oBtn42, oBtn52, oBtn62, oBtn72, oBtn82, oBtn92, oBtnA2,oBtnB2,oBtnC2,oBtnD2,oBtnE2,oBtnF2,oBtnG2
	Local oBtn43, oBtn53, oBtn63, oBtn73, oBtn83, oBtn93, oBtnA3,oBtnB3,oBtnC3,oBtnD3,oBtnE3

	Local oCbxSeek1, oCbxSeek2, oCbxSeek3
	Local oGetSeek1, oGetSeek2, oGetSeek3
	Local oBtnSeek1, oBtnSeek2, oBtnSeek3
	
	Local oFntBox := TFont():New( "Courier New",,-11)
	
	Local cGetSeek1   := Space(50), cGetSeek2 := Space(50), cGetSeek3 := Space(50)
	Local cCombo1     := '', cCombo2 := '', cCombo3 := ''
	Local cMsg        := 'Você não possui permissão para executar esta funcionalidade.'
	Local cMV_STATVLD := ''
	Local cParam      := ''
	
	Local aIndex1  := {}, aIndex2 := {}, aIndex3 := {}
	Local aSize    := {}
	Local aFolder  := {}
	Local aObj     := {}
   	Local aLegenda := {}
   	Local aPnls    := {}
   	Local aBmps    := {}
   
	Local oTLbx11, oTLbx12, oTLbx21, oTLbx22, oTLbx31, oTLbx32
	Local nList11:=0, nList12:=0, nList21:=0, nList22:=0, nList31:=0, nList32:=0

	Local aButton := {}
	
	Private oGride1, oGride2, oGride3
	Private oFld, oFld1, oFld2, oFld3
	Private cMV_STADISC := ''
	   
	Private bSair     := {|| .T. }
	Private bAtualiza := {|| .T. }

	dbSelectArea('SX6')
	If .NOT. SX6->( ExisteSX6('MV_STADISC') )
		CriarSX6('MV_STADISC','C','OPCOES PARA STATUS DA DISCAGEM - CSFA110.PRW','1=Ocupado;2=Inexistente;3=Só chama')
	Endif
	
	dbSelectArea('SX6')
	If .NOT. SX6->( ExisteSX6('MV_STATVLD') )
		CriarSX6('MV_STATVLD','C','OPCOES VALIDAS PARA STATUS DA DISCAGEM - CSFA110.PRW','123')
	Endif

	cMV_STADISC := GetMv('MV_STADISC')+';'
	cMV_STATVLD := GetMv('MV_STATVLD')
	
	While !Empty(cMV_STADISC)
		nP := At(';',cMV_STADISC)
		cParam := SubStr(cMV_STADISC,1,nP-1)
		If SubStr(cParam,1,1)$cMV_STATVLD
			AAdd(aSTADISC,SubStr(cMV_STADISC,1,nP-1))
		Endif
		cMV_STADISC := SubStr(cMV_STADISC,nP+1)
	End
	
	If .NOT. SX6->( ExisteSX6( 'MV_110DIM' ) )
		CriarSX6( 'MV_110DIM', 'C', 'Dimensionamento total das janelas de atendimento e consulta aos cadastros. 0 (zero) Desligado e 1 (um) ligado. CSFA110.prw', '0' )
	Endif

	AEval(aHeader1,{|p| AAdd(aIndex1,p[1]) },1,Len(aHeader1)-4)
	AEval(aHeader2,{|p| AAdd(aIndex2,p[1]) },1,Len(aHeader2)-4)
	AEval(aHeader3,{|p| AAdd(aIndex3,p[1]) },1,Len(aHeader3)-4)
	
   aFolder := {'Agendas para hoje ['+Dtoc(MsDate())+'] e atrasadas','Agendas atendidas','Agendas futuras'}
   
	aSize := {0,0,0,0,(GetScreenRes()[1]-7),(GetScreenRes()[2]-85),120}
	nLargura := aSize[5]
	nAltura  := aSize[6]
	nMeio := (nLargura/4)-33
			
	bAtualiza := {|| A110LoadAg() }
	bSair     := {|| Iif(MsgYesNo('Deseja realmente sair da Agenda do Operador Certisign?',cCadastro),(nOpc:=1,oDlg:End()),NIL)}

	//-------------------------------------------------------------
	// Atribuir a funcionalidade à tecla de atalho.
	// Caso aumente esta abrangência, utilizar a função A110SetKey.
	//-------------------------------------------------------------
	SetKey( VK_F5,  bAtualiza )
	SetKey( VK_F12, bSair )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro + ;
	   Iif(cU7_TIPO=='2',' - Supervisor: ',' - Operador: ') + cU7_COD + ;
	   Iif(Empty(cU7_CODVEN),'',' - Vendedor: ' +cU7_CODVEN) + ;
	   ' - ' + cU7_NOME ;
		FROM aSize[7],0 TO nAltura-5,nLargura COLOR CLR_BLACK,CLR_WHITE ;
		PIXEL STYLE DS_MODALFRAME STATUS
		
		AAdd(aObj,oDlg)
		oDlg:lMaximized := .T.
		oDlg:lEscClose  := .F.
		
		If Type('oMainWnd') <> 'O'
			oMainWnd := oDlg
		Endif
		
		// Painel esquerdo na MsDialog.
		oPnlLeft := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlLeft:Align := CONTROL_ALIGN_LEFT
		AAdd(aObj,oPnlLeft)
						
			//[1] função a ser executada.
			//[2] Tooltip do botão.
			//[3] Nome da imagem.
			//[4] Condição lógica para apresentar o botão ao usuário.
			AAdd(aButton,{"{|| A110LoadUser()}";
			             ,"Selecionar operadores...";
			             ,"BMPGROUP",cU7_TIPO=='2'})
			
			//Renato Ruy - 24/08/2016
			//Altera para buscar rotina do call center.
			//AAdd(aButton,{"{|| A110SetKey( 'TMKA271' )}","Rotina de manutenção de atendimentos do Televendas (Call Center)...","VENDEDOR",.T.})
			AAdd(aButton,{"{|| U_CSTMK010()}",;
			              "Rotina de manutenção de atendimentos do Televendas (Call Center)...",;
			              "VENDEDOR",.T.})
			
			AAdd(aButton,{"{|| A110SetKey( 'CSFA030' )}",;
			              "Telemarketing - atendimento receptivo...",;
			              "NOVACELULA",.T.})
			              
			AAdd(aButton,{"{|| A110Client()}",;
			              "Consultar clientes Certisign...",;
			              "CLIENTE",.T.})
			              
			AAdd(aButton,{"{|| A110SU5()}",;
			              "Consultar contatos Certisign...",;
			              "TMKIMG32",.T.})
			              
			AAdd(aButton,{"{|| A110SZT()}",;
			              "Consultar Common Name...",;
			              "FOLDER10",.T.})
			              
			AAdd(aButton,{"{|| A110SZX()}",;
			              "Consultar ICP-Brasil...",;
			              "FOLDER12",.T.})
			              
			AAdd(aButton,{"{|| A110PAB()}",;
			              "Consultar listas importadas...";
			              ,"FOLDER5.PNG",.T.})
			
			AAdd(aButton,{"{|| A110SUS()}",;
			              "Consultar prospects...",;
			              "POSCLI",.T.})
			
			AAdd(aButton,{"{|| A110ACH()}",;
			              "Consultar suspects...",;
			              "TCFIMG16",.T.})
			
			//Renato Ruy - 11/08/16
			//Retirada operacoes da agenda.
			//AAdd(aButton,{"{|| A110Prod()}",;
			//              "Consultar produtos Certisign...",;
			//              "ESTIMG16",.T.})
			
			//AAdd(aButton,{"{|| A110TabPre()}",;
			//              "Consultar tabela de preço Vendas Diretas...",;
			//              "TAB1",.T.})
			
			AAdd(aButton,{"{|| A110Indic()}",;
			              "Consultar as quantidades de agendas...",;
			              "NG_ICO_LGDH",.T.})
			
			AAdd(aButton,{"{|| A110SetKey( 'FATA300' )}",;
			              "Acesso a rotina de Gestão de Oportunidades...",;
			              "OBJETIVO",.T.})
			
			AAdd(aButton,{"{|| A110SetKey( 'FATA310' )}",;
			              "Acesso a rotina de Apontamentos em oportunidades...",;
			              "NOTE",.T.})
			
			AAdd(aButton,{"{|| A110LoadAg() }",;
			              "Atualiza dados da agenda <F5>...",;
			              "RELOAD",.T.})
			
			If FindFunction("U_CSFA330")
				AAdd(aButton,{"{|| U_CSFA330( cA3_XCANAL, cU7_OPERAD ) }",;
				              "Panorama de atendimentos...",;
				              "HISTORIC.PNG",.T.})
			Endif
			
			AAdd(aButton,{"{|| U_CSFA111(oGride1,oGride3) }",;
			              "Inclusao Manual de Agenda...",;
			              "BMPCPO.PNG",.T.})
			              
			AAdd(aButton,{"{|| U_CSFA114() }",;
			              "Consulta Voucher...",;
			              "SDUSEEK_MDI.PNG",.T.})
			              
			AAdd(aButton,{"{|| U_CSFA116() }",;
			              "Consulta Transferências...",;
			              "BRW_PRINT.PNG",.T.})
         
			For nI := 1 To Len( aButton )
				If aButton[nI,4]
					AAdd( aObj, Array(1) )
					nObj := Len( aObj )
					aObj[ nObj ] := TBtnBmp2():New(2,2,26,26,aButton[nI,3],,,,&(aButton[nI,1]),oPnlLeft,,,.T.)
					aObj[ nObj ]:cToolTip := aButton[nI,2]
					aObj[ nObj ]:Align := CONTROL_ALIGN_TOP
				Endif		
			Next nI
					
			// Botão sair.
			oBtn9 := TBtnBmp2():New(2,2,26,26,'FINAL',,,,bSair,oPnlLeft,,,.T.)
			oBtn9:cToolTip := 'Sair da agenda do operador Certisign <F12>...'
			oBtn9:Align    := CONTROL_ALIGN_BOTTOM
			AAdd(aObj,oBtn9)
			
		// Painel allclient na MsDialog.
		oPnlRest := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlRest:Align := CONTROL_ALIGN_ALLCLIENT
		AAdd(aObj,oPnlRest)
		
			// Pastas no painel allclient.
			oFld := TFolder():New(0,0,aFolder,,oPnlRest,,,,.T.,,260,184 )
			oFld:Align := CONTROL_ALIGN_ALLCLIENT
			AAdd(aObj,oFld)
			
			oFld1 := oFld:aDialogs[1]
			oFld2 := oFld:aDialogs[2]
			oFld3 := oFld:aDialogs[3]
			AAdd(aObj,oFld1)
			AAdd(aObj,oFld2)
			AAdd(aObj,oFld3)
			
			//Pasta1
				// Painel esquerdo dentro da pasta 1.
				oPF1Left := TPanel():New(0,0,,oFld1,,,,,,40,0,.F.,.F.)
				oPF1Left:Align := CONTROL_ALIGN_LEFT
				AAdd(aObj,oPF1Left)

				// Painel allclient dentro da pasta 1.
				oPF1Rest := TPanel():New(0,0,,oFld1,,,,,,40,0,.F.,.F.)
				oPF1Rest:Align := CONTROL_ALIGN_ALLCLIENT
				AAdd(aObj,oPF1Rest)
				
				// Painel superior dentro do painel allclient da pasta 1.
				oPF1RTop := TPanel():New(0,0,,oPF1Rest,,,,,,0,13,.F.,.F.)
				oPF1RTop:Align := CONTROL_ALIGN_TOP
				AAdd(aObj,oPF1RTop)
				
				// Painel inferior dentro do painel allclient da pasta 1.
				oPF1RBottom := TPanel():New(0,0,,oPF1Rest,,,,,,0,87,.F.,.F.)
				oPF1RBottom:Align := CONTROL_ALIGN_BOTTOM
				AAdd(aObj,oPF1RBottom)
				
				// Dados da agenda.
				oGride1 := MsNewGetDados():New(0,0,1000,1000,0,,,,,,Len(aCOLS1),,,,oPF1Rest,aHeader1,aCOLS1,/*alert('[ uChange]')*/,)
				oGride1:oBrowse:BlDblClick := {||  A110DblClick( oFld:nOption ) }
				oGride1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
				oGride1:bChange := {||  A110Detail( 1, oGride1, @oTLbx11, @oTLbx12 ) }
				AAdd(aObj,oGride1)
            
				// Botões com as ações na pasta em que está posicionado.
				oBtn41 := TButton():New( 1,202,'Contatar'     ,oPF1Left,{|| A110Telefo(1,@oGride1) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn51 := TButton():New( 1,202,'Contato'      ,oPF1Left,{|| A110Contat(1,@oGride1) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn61 := TButton():New( 1,202,'Entidade'     ,oPF1Left,{|| A110Entida(1,@oGride1) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn71 := TButton():New( 1,202,'Reagendar'    ,oPF1Left,{|| A110Reagen(@oGride1)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn81 := TButton():New( 1,202,'Transferir'   ,oPF1Left,{|| A110Transf(1,@oGride1) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn91 := TButton():New( 1,202,'Tentativas'   ,oPF1Left,{|| A110Tentat(1,@oGride1) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnA1 := TButton():New( 1,202,'Filtrar'      ,oPF1Left,{|| A110Filtro(@oBtnA1)    } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnB1 := TButton():New( 1,202,'Incluir TLV'  ,oPF1Left,{|| A110IncTlv(@oGride1)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnC1 := TButton():New( 1,202,'Gera Cliente' ,oPF1Left,{||U_CSFA112(@oGride1)     } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnD1 := TButton():New( 1,202,'Rastrear'	  ,oPF1Left,{||CSFA110I(@oGride1)      } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnE1 := TButton():New( 1,202,'Proposta'	  ,oPF1Left,{||U_A322IPro(@oGride1)    } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnF1 := TButton():New( 1,202,'Conhecimento' ,oPF1Left,{||CSFA110C(@oGride1)      } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnG1 := TButton():New( 1,202,'Oportunidade' ,oPF1Left,{||A110oportu(@oGride1)	   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
								
				oBtn41:Align := CONTROL_ALIGN_TOP
				oBtn51:Align := CONTROL_ALIGN_TOP
				oBtn61:Align := CONTROL_ALIGN_TOP
				oBtn71:Align := CONTROL_ALIGN_TOP
				oBtn81:Align := CONTROL_ALIGN_TOP
				oBtn91:Align := CONTROL_ALIGN_TOP
				oBtnA1:Align := CONTROL_ALIGN_TOP
				oBtnB1:Align := CONTROL_ALIGN_TOP
				oBtnC1:Align := CONTROL_ALIGN_TOP
				oBtnD1:Align := CONTROL_ALIGN_TOP
				oBtnE1:Align := CONTROL_ALIGN_TOP
				oBtnF1:Align := CONTROL_ALIGN_TOP
				oBtnG1:Align := CONTROL_ALIGN_TOP
				
				AAdd( aObj ,oBtn41 )
				AAdd( aObj ,oBtn51 )
				AAdd( aObj ,oBtn61 )
				AAdd( aObj ,oBtn71 )
				AAdd( aObj ,oBtn81 )
				AAdd( aObj ,oBtn91 )
				AAdd( aObj ,oBtnA1 )
				AAdd( aObj ,oBtnB1 )
				AAdd( aObj ,oBtnC1 )
				AAdd( aObj ,oBtnD1 )
				AAdd( aObj ,oBtnE1 )
				AAdd( aObj ,oBtnF1 )
				AAdd( aObj ,oBtnG1 )				
            
				// Mecanismo de busca da primeira pasta.
				oCbxSeek1 := TComboBox():New( 1,1,{|u| If(PCount()>0,cCombo1:=u,cCombo1)},aIndex1,100,20,oPF1RTop,,{|| cGetSeek1:=Space(50)},,,,.T.,,,,,,,,,"cCombo1")
				oGetSeek1 := TGet():New( 1,103,{|u| If(PCount()>0,cGetSeek1:=u,cGetSeek1)},oPF1RTop,150,9,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGetSeek1)
				oBtnSeek1 := TButton():New( 1,255,'Pesquisar',oPF1RTop,{||  A110PesqAg( oGride1, oCbxSeek1:nAt, cGetSeek1 ) },35,11,,,.F.,.T.,.F.,,.F.,,,.F.)
				oBtnSeek1:cTooltip := '(*) antes da palavra a ser pesquisada torna uma pesquisa avançada, não precisa informar a coluna.'
				
				AAdd(aObj,oCbxSeek1)
				AAdd(aObj,oGetSeek1)
				AAdd(aObj,oBtnSeek1)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx11 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList11:=u,nList11)},{},nMeio,046,,oPF1RBottom,,,,.T.,,,oFntBox)
				OTLbx11:cToolTip := 'Duplo clique permite alterar os dados.'
				oTLbx11:Align := CONTROL_ALIGN_LEFT
				oTLbx11:bLDblClick := {|| A110AltSU5( @oTLbx11, @oTLbx12, oGride1 ) } 
				AAdd(aObj,oTLbx11)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx12 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList12:=u,nList12)},{},nMeio,046,,oPF1RBottom,,,,.T.,,,oFntBox)
				OTLbx12:cToolTip := 'Duplo clique permite alterar os dados.'
				oTLbx12:Align := CONTROL_ALIGN_RIGHT
				oTLbx12:bLDblClick := {|| A110AltSU5( @oTLbx11, @oTLbx12, oGride1 ) } 
				AAdd(aObj,oTLbx12)				
			//Pasta2
				// Painel esquerdo dentro da pasta 2.
				oPF2Left := TPanel():New(0,0,,oFld2,,,,,,40,0,.F.,.F.)
				oPF2Left:Align := CONTROL_ALIGN_LEFT
				AAdd(aObj,oPF2Left)
				
				// Painel allclient dentro da pasta 2.
				oPF2Rest := TPanel():New(0,0,,oFld2,,,,,,40,0,.F.,.F.)
				oPF2Rest:Align := CONTROL_ALIGN_ALLCLIENT
				AAdd(aObj,oPF2Rest)
				
				// Painel superior dentro do painel allclient da pasta 2.
				oPF2RTop := TPanel():New(0,0,,oPF2Rest,,,,,,0,13,.F.,.F.)
				oPF2RTop:Align := CONTROL_ALIGN_TOP
				AAdd(aObj,oPF2RTop)
				
				// Painel inferior dentro do painel allclient da pasta 2.
				oPF2RBottom := TPanel():New(0,0,,oPF2Rest,,,,,,0,87,.F.,.F.)
				oPF2RBottom:Align := CONTROL_ALIGN_BOTTOM
				AAdd(aObj,oPF2RBottom)
				
				// Dados da agenda.
				oGride2 := MsNewGetDados():New(1,1,1000,1000,0,,,,,,Len(aCOLS2),,,,oPF2Rest,aHeader2,aCOLS2,/*alert('[ uChange]')*/,)
				oGride2:oBrowse:BlDblClick := {||  A110DblClick( oFld:nOption ) }
				oGride2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
				oGride2:bChange := {||  A110Detail( 2, oGride2, @oTLbx21, @oTLbx22 ) }
				AAdd(aObj,oGride2)
				
				// Botões com as ações na pasta em que está posicionado.
				oBtn52 := TButton():New( 1,202,'Contato'      ,oPF2Left ,{|| A110Contat(2,@oGride2) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn62 := TButton():New( 1,202,'Entidade'     ,oPF2Left ,{|| A110Entida(2,@oGride2) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn72 := TButton():New( 1,202,'Oportunidade' ,oPF2Left ,{|| A110oportu(@oGride2)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn92 := TButton():New( 1,202,'Tentativas'   ,oPF2Left ,{|| A110Tentat(2,@oGride2) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnA2 := TButton():New( 1,202,'Incluir TLV'  ,oPF2Left ,{|| A110IncTlv(@oGride2)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnB2 := TButton():New( 1,202,'Classificar'  ,oPF2Left ,{|| A110Clas(@oGride2)     } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				//oBtnC2 := TButton():New( 1,202,'Gerar TLV'  ,oPF2Left ,{|| U_CSFA113(@oGride2)    } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnD2 := TButton():New( 1,202,'Gera Cliente' ,oPF2Left ,{||U_CSFA112(@oGride2)     } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnE2 := TButton():New( 1,202,'Rastrear'	    ,oPF2Left ,{||CSFA110I(@oGride2)      } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnF2 := TButton():New( 1,202,'Proposta'	    ,oPF2Left ,{||U_A322IPro(@oGride2)    } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnG2 := TButton():New( 1,202,'Conhecimento' ,oPF2Left ,{||CSFA110C(@oGride2)      } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )

				oBtn52:Align := CONTROL_ALIGN_TOP
				oBtn62:Align := CONTROL_ALIGN_TOP
				oBtn72:Align := CONTROL_ALIGN_TOP
				oBtn92:Align := CONTROL_ALIGN_TOP
				oBtnA2:Align := CONTROL_ALIGN_TOP
				oBtnB2:Align := CONTROL_ALIGN_TOP
				//oBtnC2:Align := CONTROL_ALIGN_TOP
				oBtnD2:Align := CONTROL_ALIGN_TOP
				oBtnE2:Align := CONTROL_ALIGN_TOP
				oBtnF2:Align := CONTROL_ALIGN_TOP
				oBtnG2:Align := CONTROL_ALIGN_TOP
				
				AAdd(aObj,oBtn52)
				AAdd(aObj,oBtn62)
				AAdd(aObj,oBtn72)
				AAdd(aObj,oBtn92)
				AAdd(aObj,oBtnA2)
				AAdd(aObj,oBtnB2)
				//AAdd(aObj,oBtnC2)
				AAdd(aObj,oBtnD2)
				AAdd(aObj,oBtnE2)
				AAdd(aObj,oBtnF2)
				AAdd(aObj,oBtnG2)

				// Mecanismo de busca da primeira pasta.
				oCbxSeek2 := TComboBox():New( 1,1,{|u| If(PCount()>0,cCombo2:=u,cCombo2)},aIndex2,100,20,oPF2RTop,,{|| cGetSeek2:=Space(50)},,,,.T.,,,,,,,,,"cCombo2")
				oGetSeek2 := TGet():New( 1,103,{|u| If(PCount()>0,cGetSeek2:=u,cGetSeek2)},oPF2RTop,150,9,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGetSeek2)
				oBtnSeek2 := TButton():New( 1,255,'Pesquisar',oPF2RTop,{||  A110PesqAg( oGride2, oCbxSeek2:nAt, cGetSeek2 ) },35,11,,,.F.,.T.,.F.,,.F.,,,.F.)
				oBtnSeek2:cTooltip := '(*) antes da palavra a ser pesquisada torna uma pesquisa avançada, não precisa informar a coluna.'
				
				AAdd(aObj,oCbxSeek2)
				AAdd(aObj,oGetSeek2)
				AAdd(aObj,oBtnSeek2)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx21 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList21:=u,nList21)},{},nMeio,046,,oPF2RBottom,,,,.T.,,,oFntBox)
				oTLbx21:Align := CONTROL_ALIGN_LEFT
				oTLbx21:bLDblClick := {|| MsgAlert('Somente agendas em aberto é possível alterar.') } 
				AAdd(aObj,oTLbx21)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx22 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList22:=u,nList22)},{},nMeio,046,,oPF2RBottom,,,,.T.,,,oFntBox)
				oTLbx22:bLDblClick := {|| MsgAlert('Somente agendas em aberto é possível alterar.') } 
				oTLbx22:Align := CONTROL_ALIGN_RIGHT
				AAdd(aObj,oTLbx22)
			//Pasta3
				// Painel esquerdo dentro da pasta 3.
				oPF3Left := TPanel():New(0,0,,oFld3,,,,,,40,0,.F.,.F.)
				oPF3Left:Align := CONTROL_ALIGN_LEFT
				AAdd(aObj,oPF3Left)
				
				// Painel allclient dentro da pasta 3.
				oPF3Rest := TPanel():New(0,0,,oFld3,,,,,,40,0,.F.,.F.)
				oPF3Rest:Align := CONTROL_ALIGN_ALLCLIENT
				AAdd(aObj,oPF3Rest)
				
				// Painel superior dentro do painel allclient da pasta 3.
				oPF3RTop := TPanel():New(0,0,,oPF3Rest,,,,,,0,13,.F.,.F.)
				oPF3RTop:Align := CONTROL_ALIGN_TOP
				AAdd(aObj,oPF3RTop)
				
				// Painel inferior dentro do painel allclient da pasta 3.
				oPF3RBottom := TPanel():New(0,0,,oPF3Rest,,,,,,0,87,.F.,.F.)
				oPF3RBottom:Align := CONTROL_ALIGN_BOTTOM
				AAdd(aObj,oPF3RBottom)
				
				// Dados da agenda.
				oGride3 := MsNewGetDados():New(1,1,1000,1000,0,,,,,,Len(aCOLS3),,,,oPF3Rest,aHeader3,aCOLS3,/*alert('[ uChange]')*/,)
				oGride3:oBrowse:BlDblClick := {||  A110DblClick( oFld:nOption ) }
				oGride3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
				oGride3:bChange := {||  A110Detail( 3, oGride3, @oTLbx31, @oTLbx32 ) }
				AAdd(aObj,oGride3)
				
				// Botões com as ações na pasta em que está posicionado.
				oBtn43 := TButton():New( 1,202,'Contatar'     ,oPF3Left ,{|| A110Telefo(3,@oGride3)} ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn53 := TButton():New( 1,202,'Contato'      ,oPF3Left ,{|| A110Contat(3,@oGride3)} ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn63 := TButton():New( 1,202,'Entidade'     ,oPF3Left ,{|| A110Entida(3,@oGride3)} ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn83 := TButton():New( 1,202,'Transferir'   ,oPF3Left ,{|| A110Transf(3,@oGride3)} ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtn93 := TButton():New( 1,202,'Tentativas'   ,oPF3Left ,{|| A110Tentat(3,@oGride3)} ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnA3 := TButton():New( 1,202,'Incluir TLV'  ,oPF3Left ,{|| A110IncTlv(@oGride3)  } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnB3 := TButton():New( 1,202,'Gera Cliente' ,oPF3Left ,{||U_CSFA112(@oGride3)    } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnC3 := TButton():New( 1,202,'Rastrear'	  ,oPF3Left ,{||CSFA110I(@oGride3)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnD3 := TButton():New( 1,202,'Proposta'	  ,oPF3Left ,{||U_A322IPro(@oGride3) } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnE3 := TButton():New( 1,202,'Conhecimento' ,oPF3Left ,{||CSFA110C(@oGride3)     } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )
				oBtnF3 := TButton():New( 1,202,'Oportunidade' ,oPF3Left ,{||A110oportu(@oGride3)   } ,35 ,11 ,,,.F. ,.T. ,.F. ,,.F. ,,,.F. )				
				
				oBtn43:Align := CONTROL_ALIGN_TOP
				oBtn53:Align := CONTROL_ALIGN_TOP
				oBtn63:Align := CONTROL_ALIGN_TOP
				oBtn83:Align := CONTROL_ALIGN_TOP
				oBtn93:Align := CONTROL_ALIGN_TOP
				oBtnA3:Align := CONTROL_ALIGN_TOP
				oBtnB3:Align := CONTROL_ALIGN_TOP
				oBtnC3:Align := CONTROL_ALIGN_TOP
				oBtnD3:Align := CONTROL_ALIGN_TOP
				oBtnE3:Align := CONTROL_ALIGN_TOP
				oBtnF3:Align := CONTROL_ALIGN_TOP
				
				AAdd( aObj ,oBtn43 )
				AAdd( aObj ,oBtn53 )
				AAdd( aObj ,oBtn63 )
				AAdd( aObj ,oBtn83 )
				AAdd( aObj ,oBtn93 )
				AAdd( aObj ,oBtnA3 )
				AAdd( aObj ,oBtnB3 )
				AAdd( aObj ,oBtnC3 )
				AAdd( aObj ,oBtnD3 )
				AAdd( aObj ,oBtnE3 )
				AAdd( aObj ,oBtnF3 )				

				// Mecanismo de busca da primeira pasta.
				oCbxSeek3 := TComboBox():New( 1,1,{|u| If(PCount()>0,cCombo3:=u,cCombo3)},aIndex3,100,20,oPF3RTop,,{|| cGetSeek3:=Space(50)},,,,.T.,,,,,,,,,"cCombo3")
				oGetSeek3 := TGet():New( 1,103,{|u| If(PCount()>0,cGetSeek3:=u,cGetSeek3)},oPF3RTop,150,9,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGetSeek3)
				oBtnSeek3 := TButton():New( 1,255,'Pesquisar',oPF3RTop,{|| A110PesqAg( oGride3, oCbxSeek3:nAt, cGetSeek3 ) },35,11,,,.F.,.T.,.F.,,.F.,,,.F.)
				oBtnSeek3:cTooltip := '(*) antes da palavra a ser pesquisada torna uma pesquisa avançada, não precisa informar a coluna.'
				
				AAdd(aObj,oCbxSeek3)
				AAdd(aObj,oGetSeek3)
				AAdd(aObj,oBtnSeek3)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx31 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList31:=u,nList31)},{},nMeio,046,,oPF3RBottom,,,,.T.,,,oFntBox)
				OTLbx31:cToolTip := 'Duplo clique permite alterar os dados.'
				oTLbx31:Align := CONTROL_ALIGN_LEFT
				oTLbx31:bLDblClick := {|| A110AltSU5( @oTLbx31, @oTLbx32, oGride3 ) } 
				AAdd(aObj,oTLbx31)
				
				// Detalhe dos dados da agenda em que está posicionado.
				oTLbx32 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList32:=u,nList32)},{},nMeio,046,,oPF3RBottom,,,,.T.,,,oFntBox)
				OTLbx32:cToolTip := 'Duplo clique permite alterar os dados.'
				oTLbx32:Align := CONTROL_ALIGN_RIGHT
				oTLbx32:bLDblClick := {|| A110AltSU5( @oTLbx31, @oTLbx32, oGride3 ) } 
				AAdd(aObj,oTLbx32)
				AAdd(aObj,oFntBox)	

			//------------------------------------------------------------------------------------
			// Mecanismo para apresentar a legenda de cores nas pastas de cada agenda do operador.
			//------------------------------------------------------------------------------------
			AAdd(aLegenda,{LoadBitmap(,SIM_E_RETORNO),Space(6)+'É retorno de agenda.'    ,oPF1RTop,oPF2RTop,oPF3RTop})
			AAdd(aLegenda,{LoadBitmap(,NAO_E_RETORNO),Space(6)+'Não é retorno de agenda.',oPF1RTop,oPF2RTop,oPF3RTop})
			
			aPnls := Array(Len(aFolder)*Len(aLegenda))
			aBmps := Array(Len(aFolder)*Len(aLegenda))
			
			For nI := 1 To Len( aFolder )
				For nG := 1 To Len( aLegenda )
					aPnls[Len(aPnls)] := TPanel():New(0,0,aLegenda[nG,2],aLegenda[nG,nI+2],,.F.,,,,12,100,.F.,.F.)
					aPnls[Len(aPnls)]:Align := CONTROL_ALIGN_RIGHT
					aPnls[Len(aPnls)]:nWidth := 140
				
					aBmps[Len(aBmps)] := TBitmap():New(0,0,10,10,aLegenda[nG,1]:cName,,,aPnls[Len(aPnls)],,,,,,,,,.T.,,)
					aBmps[Len(aBmps)]:lAutoSize := .T.
					
					AAdd(aObj,aPnls[Len(aPnls)])
					AAdd(aObj,aBmps[Len(aBmps)])
				Next nG
			Next nI
			
	ACTIVATE MSDIALOG oDlg ON INIT A110OnInit()
	SetKey( VK_F5, NIL )
	SetKey( VK_F12, NIL )
	If nOpc == 1
		A110FreeOb(@aObj)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110IncTlv   | Autor | Robson Gonçalves   | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para inserir um atendimento de televendas a partir da 
//        | agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110IncTlv( oGride )
	Local cMsg        := ''
	Local cU4_CODLIG  := ''
	Local cU6_ATENDIM := ''
	Local cU6_ENTIDA  := ''
	Local cU6_CODENT  := ''
	Local cU6_CONTATO := ''
	Local cUC_TELEVEN := ''
	Local cCodAten    := ""
	Local aDadoPar    := {}
	Local aPergs      := {}
	Local aRet        := {}
	Local lRet    
	Local aArea       := {}
	Local nAviso      := 0
	Private aRotina   := {}
	Private oGrdOrig  := oGride
	
	aRotina := {{'','',0,1},{'','',0,2},{'','',0,3},{'','',0,4},{'','',0,5}}
	
	cU4_CODLIG := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U4_CODLIG' } ) ]
	cU6_ATENDIM := Left( oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_ATENDIM' } ) ], 6 )
	cCodAten	  := SubStr(Iif(Empty(cU6_ATENDIM),cU4_CODLIG,cU6_ATENDIM),1,6)
	
	If Empty( cU6_ATENDIM ) .And. Empty( cU4_CODLIG )
		MsgInfo('Esta agenda não possui atendimento. Somente agenda com atendimento é possível incluir um Televendas vinculado a esta agenda.', cCadastro )
	Else
		cUC_TELEVEN := Posicione( 'SUC', 1, xFilial( 'SUC' ) + Iif(Empty(cU6_ATENDIM),cU4_CODLIG,cU6_ATENDIM), 'UC_TELEVEN' )
		aArea := { SUA->( GetArea() ), SUB->( GetArea() ), SUC->( GetArea() ), SUD->( GetArea() ) }
		If Empty( cUC_TELEVEN )
			cU6_ENTIDA  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_ENTIDA' } ) ]
			cU6_CODENT  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_CODENT' } ) ]
			cU6_CONTATO := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_CONTATO' } ) ]
			
			dbSelectArea( 'SUB' )
			dbSetOrder( 1 )
			
			dbSelectArea( 'SUA' )
			dbSetOrder( 1 )
	      
			INCLUI := .T.
			ALTERA := .F.
			
			TK380OK( cU6_ATENDIM, cU6_ENTIDA, cU6_CODENT, cU6_CONTATO, cU4_CODLIG )
			
		Else
			cMsg := 'Esta agenda gerou o atendimento no televendas Nº ' + Left( cUC_TELEVEN, 6 ) + ;
			        ' pelo usuário ' + RTrim( UsrFullName( SubStr( cUC_TELEVEN, 7, 6 ) ) ) + ;
			        ' em ' + Dtoc( Stod( SubStr( cUC_TELEVEN, 13, 8 ) ) ) + ;
			        ' as ' + SubStr( cUC_TELEVEN, 21, 2 ) + ':' + SubStr( cUC_TELEVEN, 23, 2 ) + ':' + Right( cUC_TELEVEN, 2 )+'. '+;
			        'Agora você tem a oportunidade de visualizar na íntegra os dados do Televendas, por favor, selecione uma das opções abaixo'
			nAviso := Aviso('Incluir Televendas',cMsg,{'Novo','Visualizar','Sair'},2,cCadastro)
			If nAviso == 2
			    
				INCLUI := .F.
				ALTERA := .F.
				
				//Renato Ruy - 02/08/16
				//Novo tratamento para visualização de mais de um televendas vinculado ao atendimento. 
				
				//Considero a informação dos vinculos antigos.
				SUA->( dbSetOrder( 1 ) )
				If SUA->( dbSeek( xFilial( 'SUA' ) + Left( cUC_TELEVEN, 6 ) ) )
					If Empty(SUA->UA_XORIG) //Desconsidera para não duplicar
						AADD(aDadoPar,AllTrim(Str(SUA->(RecNo())))+"="+SUA->UA_NUM)
					Endif
				Endif
				
				//Se posiciona no novo vinculo.
				SUA->( dbSetOrder( 12 ) )
				If SUA->( dbSeek( xFilial( 'SUA' ) + cCodAten ) )
					
					While !SUA->(EOF()) .And. SUA->UA_XORIG == cCodAten
					
						AADD(aDadoPar,AllTrim(Str(SUA->(RecNo())))+"="+SUA->UA_NUM)
						
					    SUA->(Dbskip())
					Enddo
					
					If Len(aDadoPar) == 1
						TK271CallCenter( 'SUA', Val( SubStr(aDadoPar[1],1, AT("=",aDadoPar[1])-1) ), 2 )
					Else
						aAdd( aPergs ,{2,"Selecione o Atendimento","", aDadoPar, 50,'.T.',.T.})
						If ParamBox(aPergs ,"Parametros ",aRet)
							TK271CallCenter( 'SUA', Val(aRet[1]), 2 )
						Endif
					EndIf
				
				Else
					SUA->( dbSetOrder( 1 ) )
					If SUA->( dbSeek( xFilial( 'SUA' ) + Left( cUC_TELEVEN, 6 ) ) )
						TK271CallCenter( 'SUA', SUA->( RecNo() ), 2 )
					Else
						MsgAlert('Não localizei o atendimento em questão.', cCadastro )
					Endif
				Endif
			Elseif nAviso == 1
				cU6_ENTIDA  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_ENTIDA' } ) ]
				cU6_CODENT  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_CODENT' } ) ]
				cU6_CONTATO := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_CONTATO' } ) ]
				
				dbSelectArea( 'SUB' )
				dbSetOrder( 1 )
				
				dbSelectArea( 'SUA' )
				dbSetOrder( 1 )
		      
				INCLUI := .T.
				ALTERA := .F.
				
				TK380OK( cU6_ATENDIM, cU6_ENTIDA, cU6_CODENT, cU6_CONTATO, cU4_CODLIG )
			Endif
		Endif
		AEval( aArea, {|xArea| RestArea( xArea ) } )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | TK380OK      | Autor | Robson Gonçalves   | Data | 26.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para executar TK271CallCenter. O objetivo é desviar 
//        | da verificação para não limpar as variáveis de contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function TK380OK( cU6_ATENDIM, cU6_ENTIDA, cU6_CODENT, cU6_CONTATO, cU4_CODLIG ) 
	
	Private c110_UC_COD := ''
	lTK271 := .T.
	c110_UC_COD := Iif(Empty(cU6_ATENDIM),cU4_CODLIG,cU6_ATENDIM)
	If cU6_ENTIDA == 'SA1' 
		TK271CallCenter('SUA',SUA->(RecNo()),3,/*aEnchoice*/,Left(cU6_CODENT,6),SubStr(cU6_CODENT,7,2),cU6_CONTATO,cU6_ENTIDA,/*aTLC*/,/*cAgenda*/,/*lAuto*/,/*cMens*/)
	Else
		TK271CallCenter('SUA',SUA->(RecNo()),3)
	Endif
	lTK271 := .F.
	c110_UC_COD := ''
Return

//-----------------------------------------------------------------------
// Rotina | A110TKEnd    | Autor | Robson Gonçalves   | Data | 27.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TK271END, o objetivo é
//        | vincular o atendimento feito pela agenda do operador com um
//        | atendimento do televendas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110TKEnd()

	Local aCodObj := {}
	Local lLock   := .F.
	
	If ValType( lTK271 ) == 'L'
		If lTK271
			SUC->( dbSetOrder( 1 ) )
			If SUC->( dbSeek( xFilial( 'SUC' ) + c110_UC_COD ) )
			
				//Renato Ruy - 21/07/2016
				//Cria banco de conhecimento através da SUC para o televendas.
				AC9->(DbSetOrder(2))
				If AC9->(DbSeek(xFilial("AC9")+"SUC"+xFilial("SUC")+SUC->UC_FILIAL+c110_UC_COD))
					//Busco todos os objetos existente
					While !AC9->(EOF()) .And. SUC->UC_FILIAL+SUC->UC_CODIGO == AllTrim(AC9->AC9_CODENT)
						AADD(aCodObj,AC9->AC9_CODOBJ)
						AC9->(DbSkip())
					Enddo
					
					
					For nI := 1 to Len(aCodObj)
					
						//Gravo todos itens para a tabela SUA.
						AC9->(RecLock("AC9",.T.))
							AC9->AC9_FILIAL := xFilial("AC9")
							AC9->AC9_FILENT := xFilial("SUA")
							AC9->AC9_ENTIDA := "SUA"
							AC9->AC9_CODENT := xFilial("SUA")+M->UA_NUM
							AC9->AC9_CODOBJ := aCodObj[nI]
							AC9->AC9_DTGER  := dDatabase
						AC9->(MsUnlock())
					
						//+--------------------------------------+
						//| David.Santos - 04/11/2016            |
						//| Gravo todos itens para a tabela SC5. |
						//+--------------------------------------+	
						AC9->(RecLock("AC9",.T.))
							AC9->AC9_FILIAL := xFilial("AC9")
							AC9->AC9_FILENT := xFilial("SC5")
							AC9->AC9_ENTIDA := "SC5"
							AC9->AC9_CODENT := SC5->C5_NUM
							AC9->AC9_CODOBJ := aCodObj[nI]
							AC9->AC9_DTGER  := dDatabase
						AC9->(MsUnlock())
						
					Next
					
				EndIf
				
				If SUA->(MsSeek(xFilial("SUA") + M->UA_NUM))
					lLock := SUA->( MsRLock( RecNo() ) )
					If lLock
						SUA->( MsRUnLock( RecNo() ) )
					Endif  
					//Renato Ruy - 02/08/2016
					//Vincula mais de um atendimento 
					SUA->( RecLock( 'SUA', .F. ) )
						SUA->UA_XORIG := SubStr(c110_UC_COD,1,6)
					SUA->( MsUnLock() )
				EndIf
								
				If Empty(SUC->UC_TELEVEN)
					SUC->( RecLock( 'SUC', .F. ) )
						SUC->UC_TELEVEN := M->UA_NUM + RetCodUsr() + Dtos( dDataBase ) + StrTran( Time(), ':', '' )
					SUC->( MsUnLock() )
				EndIf
				MsgInfo( 'O atendimento Nº ' + c110_UC_COD + ' agora está vinculado com o televendas Nº ' + M->UA_NUM + '.', 'Vínculo de documentos')
			Else
				MsgAlert('Não localizado o atendimento Nº ' + c110_UC_COD, 'Vínculo de documentos' )
			Endif
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
				dbSelectArea("ACV")
				dbSetOrder(5)
				While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
					If ACV->(dbSeek(xFilial("ACV") + SC6->C6_PRODUTO))
						RecLock("SC6",.F.)
							SC6->C6_UNEG := ACV->ACV_CATEGO 
						SC6->(MsUnlock())
					EndIf
					SC6->(dbSkip())
				EndDo
			EndIf
						
		Endif
		lTK271 := .F.
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110AltSU5   | Autor | Robson Gonçalves   | Data | 04.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para alterar os dados do contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110AltSU5( oTLbx1, oTLbx2, oGride )
	Local cIni        := ''
	Local cCpo        := ''
	Local cBkp        := ''
	Local cWhen       := ''
	Local cValid      := ''
	Local cU6_CONTATO := ''
	Local cU6_CODENT  := ''
	Local cU6_ENTIDA  := ''
	
	Local lAlpha := .F.
	
	Local nI := 0
	Local nJ := 0
	
	Local aCpo := {}
	Local aPar := {}
	Local aRet := {}
	Local aSX3 := {}
	
	//---------------------------------------------------------------------------------
	// Posição dos campos na TList de contato. Precisa ser Static por causa das macros.
	//---------------------------------------------------------------------------------
	Static nU5_CONTAT  := 3
	Static nU5_DDD     := 5
	Static nU5_FONE    := 6
	Static nU5_CELULAR := 7
	Static nU5_FCOM1   := 8
	Static nU5_FCOM2   := 9
	Static nU5_EMAIL   := 10
	Static nZT_CNPJ    := 4
	Static nZX_NRCNPJ  := 13
	Static nPAB_CNPJ   := 10
	Static nU5_FUNCAO  := 15
	Static nPAB_CONCOR := 16
	Static nZT_CONCORR := 16
	Static nZX_CONCORR := 16
	Static nU5_CONCORR := 16
	
	//----------------------------
	// Campos que serão alterados.
	//----------------------------
	AAdd( aCpo, 'U5_CONTAT' )
	AAdd( aCpo, 'U5_DDD'    )
	AAdd( aCpo, 'U5_FONE'   )
	AAdd( aCpo, 'U5_CELULAR')
	AAdd( aCpo, 'U5_FCOM1'  )
	AAdd( aCpo, 'U5_FCOM2'  )
	AAdd( aCpo, 'U5_EMAIL'  )
	AAdd( aCpo, 'U5_FUNCAO' )
	AAdd( aCpo, ''          )
	AAdd( aCpo, ''          )
		
	//------------------------------------------
	// Capturar código do contato e da entidade.
	//------------------------------------------
	cU6_CONTATO := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|e| e[ 2 ]=='U6_CONTATO' }) ]
	cU6_CODENT  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|e| e[ 2 ]=='U6_CODENT'  }) ]
	cU6_ENTIDA  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|e| e[ 2 ]=='U6_ENTIDA'  }) ]
	
	If .NOT. (cU6_ENTIDA $ 'PAB|SZT|SZX')
		MsgAlert('Operação de alterar dados não permitido para esta entidade.',cCadastro)
		Return
	Endif
	
	aCpo[ 09 ] := Iif( cU6_ENTIDA == 'PAB', 'PAB_CNPJ'  , IIf( cU6_ENTIDA == 'SZT', 'ZT_CNPJ'   , Iif( cU6_ENTIDA == 'SZX', 'ZX_NRCNPJ' ,'') ) )
	aCpo[ 10 ] := Iif( cU6_ENTIDA == 'PAB', 'PAB_CONCOR', IIf( cU6_ENTIDA == 'SZT', 'ZT_CONCORR', Iif( cU6_ENTIDA == 'SZX', 'ZX_CONCORR','') ) )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpo )
		SX3->( dbSeek( aCpo[ nI ] ) )
		aSX3 := SX3->( GetAdvFVal( 'SX3', { 'X3_TITULO', 'X3_TAMANHO', 'X3_PICTURE' }, aCpo[ nI ], 2 ) )
		//---------------------------------------
		// Estes campos deverão ter a picture @!.
		//---------------------------------------
		If aCpo[ nI ] $ 'U5_FONE|U5_CELULAR|U5_FCOM1|U5_FCOM2|U5_CONCORR'
			aSX3[ 3 ] := '@!'
		Endif
		//---------------------------------------------------
		// Caso seja o CNPJ e não houver picture, forçar uma.
		//---------------------------------------------------
		If nI == 9 .AND. Empty( aSX3[ 3 ] )
			aSX3[ 3 ] := '@R 99.999.999/9999-99'
		Endif
		//-------------------------------------------------------------------
		// Capturar o conteúdo do campo do contato e mais o espaço em branco.
		//-------------------------------------------------------------------
		cCpo := 'n' + aCpo[ nI ]		
		
		If 'CNPJ' $ aCpo[ nI ]
			cIni   := PadR( SubStr( oTLbx2:aITEMS[ &(cCpo) ], 15 ), aSX3[ 2 ], ' ')
			cValid := 'CGC( MV_PAR09 )'
			cWhen  := Iif( .NOT. Empty( cIni ), '.F.', '.T.')
			If cWhen == '.F.'
				cBkp := cIni
				cIni := AllTrim( cIni )
				For nJ := 1 To Len( cIni )
					If .NOT. ( SubStr( cIni, nJ, 1 ) $ '0123456789' )
						lAlpha := .T.
						Exit
					Endif
				Next nI
				If lAlpha
					cWhen := '.T.'
				Endif
				cIni := cBkp
			Endif
		Else
			cIni   := PadR( SubStr( oTLbx1:aITEMS[ &(cCpo) ], 15 ), aSX3[ 2 ], ' ')	
			cValid := ''
			cWhen  := '.T.'
		Endif		
		//---------------------------------------
		// Montar o campo para a função Parambox.
		//---------------------------------------
		If aCpo[ nI ] == 'U5_FUNCAO'
			cValid := "ExistCpo('SUM')"
			AAdd( aPar, { 1, RTrim( aSX3[ 1 ] ), cIni, aSX3[ 3 ], cValid, 'SUM', cWhen, 06, SX3->( X3Obrigat( aCpo[ nI ] ) ) } )
		Else
			AAdd( aPar, { 1, RTrim( aSX3[ 1 ] ), cIni, aSX3[ 3 ], cValid, ''   , cWhen, 110, Iif("CNPJ"$aCpo[ nI ],.F.,SX3->( X3Obrigat( aCpo[ nI ] ) )) } )
		EndIf
	Next nI
	
	cBkp := cCadastro 
	cCadastro := 'Agenda do Operador'
	If ParamBox( aPar, 'Alterar dados do contato/CNPJ da entidade', @aRet,,,,,,,,.F.,.F.)	
		//-------------------------------
		// Atualizar o aCOLS da GetDados.
		//-------------------------------
		oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2]=='U5_CONTAT' } ) ] := aRet[ 1 ]
		SU5->( dbSetOrder( 1 ) )
		If SU5->( dbSeek( xFilial( 'SU5' ) + cU6_CONTATO ) )
			SU5->( RecLock( 'SU5', .F. ) )
			//------------------------------------------
			// Atualizar os campos na tabela de contato.
			//------------------------------------------
			For nI := 1 To Len( aCpo )//-1
				SU5->( FieldPut( FieldPos( aCpo[ nI ] ), aRet[ nI ] ) )
				//-----------------------------
				// Elaborar o nome da variável.
				//-----------------------------
				cCpo := 'n' + aCpo[ nI ] 
				//-------------------
				// Atualizar a TList.
				//-------------------
				oTLbx1:Modify( SX3->( RetTitle( aCpo[ nI ] ) ) + ': ' + aRet[ nI ], &(cCpo) )
			Next nI
			SU5->( MsUnLock() )
			//-------------------------------------------
			// Atualizar os dados da entidade e na TList.
			//-------------------------------------------
			If cU6_ENTIDA == 'SZT'
				SZT->( dbSetOrder( 1 ) )
				If SZT->( dbSeek( xFilial( 'SZT' ) + cU6_CODENT ) )
					SZT->( RecLock( 'SZT', .F. ) )
					SZT->ZT_NOME    := aRet[ 1 ]
					SZT->ZT_CONTTEC := aRet[ 7 ]
					SZT->ZT_FONE    := aRet[ 2 ] + aRet[ 5 ]
					SZT->ZT_CNPJ    := aRet[ 9 ]
					SZT->ZT_CONCORR := aRet[ 10 ]
					SZT->( MsUnLock() )
					oTLbx2:Modify( SX3->( RetTitle('ZT_NOME') )   + ': ' + aRet[ 1 ], 8 )
					oTLbx2:Modify( SX3->( RetTitle('ZT_CONTTEC') )+ ': ' + aRet[ 7 ], 7 )
					oTLbx2:Modify( SX3->( RetTitle('ZT_FONE') )   + ': ' + aRet[ 2 ] + aRet[ 5 ], 11 )
					oTLbx2:Modify( SX3->( RetTitle('ZT_CNPJ') )   + ': ' + TransForm( aRet[ 9 ], '@R 99.999.999/9999-99' ) , 4 )
					oTLbx2:Modify( SX3->( RetTitle('ZT_CONCORR') ) + ': ' + rTrim(aRet[ 10 ]), 16 )
				Endif
			Elseif cU6_ENTIDA == 'SZX'
				SZX->( dbSetOrder( 1 ) )
				If SZX->( dbSeek( xFilial( 'SZX' ) + cU6_CODENT ) )
					SZX->( RecLock( 'SZX', .F. ) )
					SZX->ZX_NMCLIEN := aRet[ 1 ]
					SZX->ZX_DSEMAIL := aRet[ 7 ]
					SZX->ZX_NRTELEF := aRet[ 2 ] + aRet[ 5 ]
					SZX->ZX_NRCNPJ  := aRet[ 9 ]
					SZX->ZX_CONCORR := aRet[ 10 ]
					SZX->ZX_DSCARGO := Posicione('SUM',1,xFilial('SUM')+aRet[ 8 ],'UM_DESC')
					SZX->( MsUnLock() )
					oTLbx2:Modify( SX3->( RetTitle('ZX_NMCLIEN') ) + ': ' + aRet[ 1 ], 4 )
					oTLbx2:Modify( SX3->( RetTitle('ZX_DSEMAIL') ) + ': ' + aRet[ 7 ], 5 )
					oTLbx2:Modify( SX3->( RetTitle('ZX_NRTELEF') ) + ': ' + aRet[ 2 ] + aRet[ 5 ], 6 )
					oTLbx2:Modify( SX3->( RetTitle('ZX_NRCNPJ') )  + ': ' + TransForm( aRet[ 9 ], '@R 99.999.999/9999-99' ), 13 )
					oTLbx2:Modify( SX3->( RetTitle('ZX_CONCORR') ) + ': ' + rTrim(aRet[ 10 ]), 16 )
				Endif
			Elseif cU6_ENTIDA == 'PAB'
				PAB->( dbSetOrder( 1 ) )
				If PAB->( dbSeek( xFilial( 'PAB' ) + cU6_CODENT ) )
					PAB->( RecLock( 'PAB', .F. ) )
					PAB->PAB_NOME   := aRet[ 1 ]
					PAB->PAB_EMAIL  := aRet[ 7 ]
					PAB->PAB_DDD    := aRet[ 2 ]
					PAB->PAB_TELEFO := aRet[ 5 ]
					PAB->PAB_CELULA := aRet[ 4 ]
					PAB->PAB_CNPJ   := aRet[ 9 ]
					PAB->PAB_CONCOR := aRet[ 10 ]
					PAB->PAB_CARGO  := Posicione('SUM',1,xFilial('SUM')+aRet[ 8 ],'UM_DESC')
					PAB->( MsUnLock() )
					oTLbx2:Modify( SX3->( RetTitle('PAB_NOME') )   + ': ' + aRet[ 1 ], 3 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_EMAIL') )  + ': ' + aRet[ 7 ], 5 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_DDD') )    + ': ' + aRet[ 2 ], 6 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_TELEFO') ) + ': ' + aRet[ 5 ], 7 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_CELULA') ) + ': ' + aRet[ 4 ], 8 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_CNPJ') )   + ': ' + TransForm( aRet[ 9 ], '@R 99.999.999/9999-99' ), 10 )
					oTLbx2:Modify( SX3->( RetTitle('PAB_CONCOR') ) + ': ' + rTrim(aRet[ 10 ]), 16 )
				Endif
			Endif
		Endif
		oTLbx1:Refresh()
		oTLbx1:GoTop()
		If cU6_ENTIDA $ 'SZT|SZX|PAB'
			oTLbx2:Refresh()
			oTLbx2:GoTop()
		Endif
	Else
		MsgAlert('Operação de alterar dados não concluído.',cCadastro)
	Endif
	cCadastro := cBkp
Return

//-----------------------------------------------------------------------
// Rotina | A110oportu   | Autor | Robson Gonçalves   | Data | 31.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar oportunidade baseado em um atendimento.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110oportu(oGride)
	Local nLin := 0
	Local cU6_ATENDIM := ''
	Local cU6_LISTA	  := ''
	
	nLin := oGride:nAt
	
	// Capturar o número do atendimento (SUC)
	cU6_ATENDIM := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U6_ATENDIM' } ) ]
	cU4_LISTA   := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_LISTA'	  } ) ]
	
	If Empty( cU6_ATENDIM )
		MsgAlert( 'Agenda Certisign sem atendimento, atualize os dados teclando <F5>.', cCadastro)
	Else
		U_CSFA220( 'CSFA110', cU6_ATENDIM, cU4_LISTA )
	Endif
	
	oGride:oBrowse:SetFocus()
	oGride:nAt := nLin
Return

//-----------------------------------------------------------------------
// Rotina | A110SetKey   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para restaurar a tecla de atalho quando retornar de 
//        | rotina padrão.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SetKey( cRotina )
	SetKey( VK_F5, NIL )
	SetKey( VK_F12, NIL )
	//Renato Ruy - 05/08/2016 - Bloqueio de Acesso pelos usuários na rotina de televendas.
	If cRotina == 'TMKA271'
		If Upper(AllTrim(cUserName)) $ Upper(GetMV("MV_XAGETLV"))
			TMKA271()
		Else
			Msginfo("A rotina não pode ser acessada pelo usuario!")
		EndIf
	Elseif cRotina == 'CSFA030'
		U_CSFA030()
	Elseif cRotina == 'FATA300'
		FATA300()
	Elseif cRotina == 'FATA310'
		FATA310()
	Endif

	SetKey( VK_F5, bAtualiza )
	SetKey( VK_F12,bSair )
Return

//-----------------------------------------------------------------------
// Rotina | A110DblClick | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo duplo click na MsGetDados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110DblClick( nPasta )
	Local cNum        := ''
	Local cHeader     := ''
	Local cCOLS       := ''
	Local cObj        := ''
	Local cAval       := ''
	Local cHas        := ''
	Local cU4_LISTA   := ''
	Local cU6_CODIGO  := ''
	Local cU6_ATENDIM := ''
	Local cUD_CODIGO  := ''
	Local cUD_ITEM    := ''
	
	Local nAt         := 0
	Local nU4_LISTA   := 0
	Local nU6_CODIGO  := 0

	Local lDelete     := .T.
	Local lOk         := .F.
	
	cNum    := LTrim( StrZero( nPasta, 1, 0 ) )
	cObj    := 'oGride'+cNum
	cAval   := cObj+':aCOLS['+cObj+':nAt, Len('+cObj+':aCOLS['+cObj+':nAt])]'
	cHas    := cObj+':aCOLS['+cObj+':nAt,1]'
	cHeader := 'aHeader'+cNum
	cCOLS   := 'aCOLS'+cNum
	nAt     := &(cObj+':nAt')
	lDelete := &(cAval)
	
	If &(cHas) == '###'
		MsgAlert('Esta agenda foi cancelada, selecione outra agenda.',cCadastro)
	Else	
		If lDelete
			If MsgYesNo('Está ação cancela o atendimento e disponibiliza a agenda, confirma o cancelamento?',cCadastro)
				nU4_LISTA   := AScan( &(cHeader), {|p| p[2]=='U4_LISTA'})
				nU6_CODIGO  := AScan( &(cHeader), {|p| p[2]=='U6_CODIGO'})
				cU4_LISTA   := &(cCOLS)[nAt,nU4_LISTA]
				cU6_CODIGO  := &(cCOLS)[nAt,nU6_CODIGO]
				cU6_ATENDIM := SU6->(Posicione('SU6',1,xFilial('SU6')+cU4_LISTA+cU6_CODIGO,'U6_ATENDIM'))
				cUD_CODIGO  := SubStr(cU6_ATENDIM,1,Len(SUD->UD_CODIGO))
				cUD_ITEM    := SubStr(cU6_ATENDIM,Len(SUD->UD_CODIGO)+1,Len(SUD->UD_ITEM))
				If A110PodeCan( cUD_CODIGO, cUD_ITEM )
					BEGIN TRANSACTION
						Processa( {|| lOk := A110CanAten(&(cObj),nPasta)}, cCadastro,'Cancelando atendimento, aguarde...', .F. )
					END TRANSACTION
					If lOk
						MsgInfo('Operação efetuada com sucesso.',cCadastro)
					Endif
				Endif
			Endif
		Else
			A110CodLig(&(cObj),&(cHeader),&(cCOLS))
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110PodeCan | Autor | Robson Gonçalves    | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se o item pode ser cancelado em relação
//        | a atendimentos posteriores.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110PodeCan( cAtendimento, cItemAtend )
	Local cSQL := ''
	Local cTRB := ''
	Local cItem := ''
	
	Local lRet := .T.
	
	cSQL := "SELECT MAX(UD_ITEM) AS cUD_ITEM "
	cSQL += "FROM   "+RetSqlName("SUD")+" SUD "
	cSQL += "WHERE  UD_FILIAL = "+ValToSql(xFilial("SUD"))+" "
	cSQL += "       AND UD_CODIGO = "+ValToSql(cAtendimento)+" "
	cSQL += "       AND SUD.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	cItem := (cTRB)->(cUD_ITEM)
	(cTRB)->(dbCloseArea())
	
	If cItem > cItemAtend
		lRet := .F.
		MsgInfo('Não é possível cancelar esta agenda, pois há atendimentos posteriores.',cCadastro)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110CanAten | Autor | Robson Gonçalves    | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para cancelar o atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110CanAten(oGride,nPasta)
	Local nP          := 0
	Local nLin        := 0
	Local nRegistro   := 0
	Local nU4_RECNO   := 0
	Local nU6_RECNO   := 0
	Local nU4_LISTA   := 0
	Local nU6_CODIGO  := 0
	Local nU4_DESC    := 0
	
	Local cTRB        := ''
	Local cSQL        := ''
	Local cUD_ITEM    := ''
	Local cUD_CODIGO  := ''
	Local cU6_ATENDIM := ''
	Local cUD_LSTCONT := ''
	Local cLST_COD    := ''
	Local cTxtCancel  := 'AGENDA CANCELADA AUTOMATICAMENTE.'
	
	Local lSU4 := .F.
	Local lSU6 := .F.
	Local lSUC := .F.
	Local lSUD := .F.
	Local lRet := .F.
	
	ProcRegua(7)
	//------------------------------
	// Posicionar no item da agenda.
	//------------------------------
	nLin := oGride:nAt
	
	nU4_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
	nU6_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U6_RECNO'})
	
	nU4_RECNO := oGride:aCOLS[nLin,nU4_RECNO]
	nU6_RECNO := oGride:aCOLS[nLin,nU6_RECNO]

	//----------------------------------
	// Mudar o status do item da agenda.
	//----------------------------------
	SU6->(dbGoTo(nU6_RECNO))
	If SU6->(RecNo()) == nU6_RECNO
		cU6_ATENDIM := SU6->U6_ATENDIM
		If SU6->U6_STATUS <> '1'
			lSU6 := .T.
			SU6->(RecLock('SU6',.F.))
			SU6->U6_STATUS := '1'
			SU6->U6_CODOPER := ''
			SU6->U6_ATENDIM := ''
			SU6->(MsUnLock())
		Endif
	Endif
	IncProc()
	Sleep(500)	
	
	//-----------------------------------
	// Posicionar no cabeçalho da agenda.
	//-----------------------------------
	SU4->(dbGoTo(nU4_RECNO))
	If SU4->(RecNo()) == nU4_RECNO
		lSU4 := .T.
		//-------------------------------------------------------
		// Mudar o status do cabeçalho da agenda caso necessário.
		//-------------------------------------------------------
		If SU4->U4_STATUS <> '1'
			SU4->(RecLock('SU4',.F.))
			SU4->U4_STATUS := '1'
			SU4->(MsUnLock())
		Endif
	Endif
	IncProc()
	Sleep(400)	
	
	cUD_CODIGO := SubStr(cU6_ATENDIM,1,Len(SUD->UD_CODIGO))
	cUD_ITEM   := SubStr(cU6_ATENDIM,Len(SUD->UD_CODIGO)+1,Len(SUD->UD_ITEM))
	
	//----------------------------
	// Posicionar em SUD e excluir.
	//----------------------------
	SUD->(dbSetOrder(1))
	If SUD->(dbSeek(xFilial('SUD')+cUD_CODIGO+cUD_ITEM))
		lSUD := .T.
		cUD_LSTCONT := SUD->UD_LSTCONT
		SUD->(RecLock('SUD',.F.))
		SUD->(dbDelete())
		SUD->(MsUnLock())
	Endif
	IncProc()
	Sleep(300)	
	
	//--------------------------------------------
	// Veficar quantos itens possui o atendimento.
	//--------------------------------------------
	cSQL := "SELECT COUNT(*) AS nCOUNT "
	cSQL += "FROM  "+RetSqlName("SUD")+" "
	cSQL += "WHERE  UD_FILIAL = "+ValToSql(xFilial("SUD"))+" "
	cSQL += "       AND UD_CODIGO = "+ValToSql(cUD_CODIGO)+" " 
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	nRegistro := (cTRB)->(nCOUNT)
	(cTRB)->(DbCloseArea())
	IncProc()
	Sleep(200)	
	
	//---------------------------------------------------
	// Posicionar em SUC e excluir ou modificar o status.
	//---------------------------------------------------
	SUC->(dbSetOrder(1))
	If SUC->(dbSeek(xFilial('SUC')+cUD_CODIGO))
		lSUC := .T.
		SUC->(RecLock('SUC',.F.))
		//---------------------------------------------------------------------------------
		// Se não localizou registro, apagar, do contrário modificar o status do cabeçalho.
		//---------------------------------------------------------------------------------
		If nRegistro == 0
			SUC->(dbDelete())
		Else
			//--------------------------------------------------------------------------------------------------
			// 1 no UC_STATUS é planejada, 2 é pendente e 3 é encerrada, isso foi compatibilizado com UD_STATUS.
			//--------------------------------------------------------------------------------------------------
			If SUC->UC_STATUS == '3'
				SUC->UC_STATUS := '2'
			Endif
		Endif
		SUC->(MsUnLock())
	Endif
	IncProc()
	Sleep(150)
	
	//-----------------------------------------
	// Verificar se o atendimento gerou agenda.
	//-----------------------------------------
	If !Empty(cUD_LSTCONT)
		SU6->(dbSetOrder(1))
		If SU6->(dbSeek(xFilial('SU6')+cUD_LSTCONT))
			SU4->(dbSetOrder(1))
			If SU4->(dbSeek(xFilial('SU4')+SU6->U6_LISTA))
				cLST_COD := SU6->(U6_LISTA+U6_CODIGO)
				
				SU6->(RecLock('SU6',.F.))
				SU6->(dbDelete())
				SU6->(MsUnLock())
				
				SU4->(RecLock('SU4',.F.))
				SU4->(dbDelete())
				SU4->(MsUnLock())
			
				//------------------------------------------------------------------------------------------------
				// Verificar se que foi excluída está no aCOLS1 ou aCOLS3, se estiver deletar e alterar os rencos.
				//------------------------------------------------------------------------------------------------
				nU4_DESC   := AScan(oGride:aHeader,{|p| p[2]=='U4_DESC'})
				nU4_LISTA  := AScan(oGride:aHeader,{|p| p[2]=='U4_LISTA'})
				nU6_CODIGO := AScan(oGride:aHeader,{|p| p[2]=='U6_CODIGO'})
				
				nP := AScan(oGride:aCOLS,{|p| p[nU4_LISTA]+p[nU6_CODIGO]==cLST_COD })
				If nP > 0
					oGride:aCOLS[nP,1] := '###'
					oGride:aCOLS[nP,nU4_DESC] := cTxtCancel
					oGride:aCOLS[nP,Len(oGride:aCOLS[1])] := .T.
				Else
					If nPasta==1
						nP := AScan(oGride3:aCOLS,{|p| p[nU4_LISTA]+p[nU6_CODIGO]==cLST_COD })
						If nP > 0
							oGride3:aCOLS[nP,1] := '###'
							oGride3:aCOLS[nP,nU4_DESC] := cTxtCancel
							oGride3:aCOLS[nP,Len(oGride3:aCOLS[1])] := .T.
						Endif
					Else
						nP := AScan(oGride1:aCOLS,{|p| p[nU4_LISTA]+p[nU6_CODIGO]==cLST_COD })
						If nP > 0
							oGride1:aCOLS[nP,1] := '###'
							oGride1:aCOLS[nP,nU4_DESC] := cTxtCancel
							oGride1:aCOLS[nP,Len(oGride1:aCOLS[1])] := .T.
						Endif
					Endif
				Endif
				IncProc()
				Sleep(100)
			Endif
		Endif
	Endif
	
	//--------------------------------------------------------------------------------
	// Desfazer o delete da MsNewGetDados se conseguir fazer todos os processos acima.
	//--------------------------------------------------------------------------------
	If lSU4 .And. lSU6 .And. lSUC .And. lSUD
		lRet := .T.
		oGride:aCOLS[nLin,Len(oGride:aCOLS[nLin])] := .F.
		oGride:ForceRefresh()
	Endif
	oGride:oBrowse:SetFocus()
	oGride:nAt := nLin
	IncProc()
	Sleep(50)	
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110CodLig | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar os atendimento anteriores a agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110CodLig( oGride, aHeader, aCOLS )
	Local nLinha      := 0
	Local cU4_CODLIG  := ''
	Local cU6_ATENDIM := ''
	Local cTipoBkp    := ''
	Local cFiltra     := ''
	Local cChave      := ''
	Local aIndex      := {}
	Local lTk271Fil   := FindFunction("U_TK271FIL")
	
	Private aRotina := {}
	
	AAdd(aRotina,{'','',0,1})
	AAdd(aRotina,{'','',0,2})
	AAdd(aRotina,{'','',0,3})
	AAdd(aRotina,{'','',0,4})
	AAdd(aRotina,{'','',0,5})

	INCLUI := .F.
	ALTERA := .F.
	
	nLinha := oGride:nAt
	cU4_CODLIG := aCOLS[nLinha,AScan(aHeader,{|p| p[2]=='U4_CODLIG'})]
	cU6_ATENDIM := SubStr(aCOLS[nLinha,AScan(aHeader,{|p| p[2]=='U6_ATENDIM'})],1,Len(SUC->UC_CODIGO))
	cChave := Iif(Empty(cU4_CODLIG),cU6_ATENDIM,cU4_CODLIG)
	
	If !Empty( cChave )
	   SUC->(dbSetOrder(1))
	   If SUC->(dbSeek(xFilial('SUC')+cChave))
   		cTipoBkp := TkGetTipoAte()
			TkGetTipoAte("1")
			If lTk271Fil
				TK271MFil("SUC", @cFiltra, @aIndex )
			Endif
			TK271CallCenter('SUC',SUC->(RecNo()),2,)
			If !Empty( cFiltra ) .AND. Len( aIndex ) > 0
				EndFilBrw( "SUC", aIndex )
			Endif
			TkGetTipoAte(cTipoBkp)
		Else
			MsgInfo('Código de ligação não localizado.',cCadastro)
		Endif
	Else
		MsgInfo('Não houve atendimento para esta agenda.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110OnInit | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para preencher os GetDados inicialmente.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110OnInit()
	oGride3:ForceRefresh()
	oGride2:ForceRefresh()
	oGride1:ForceRefresh()
	oGride1:oBrowse:SetFocus()
	//Renato Ruy - 28/06/2016
	//Aviso de agendas vencidas para o operador.
	CSFA110V()
Return

//-----------------------------------------------------------------------
// Rotina | A110FreeOb | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina destuir os objetos ativos e não gerar conflitos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110FreeOb(aObj)
	Local nI := 0
	For nI := 1 To Len( aObj )
		If ValType( aObj[ nI ] ) == "O"
			FreeObj( aObj[ nI ] )
		Endif
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A110LoadUser | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para remontar os aCOLS com a nova seleção.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110LoadUser()
	Local cBackUp := ''
	Local cTRB := ''
	Local nCount := 0
	
	If Aviso(cCadastro,'Esta opção irá refazer a lista das agendas dos operadores, confirma o processamento?',{'Sim','Não'},2,'Novo processamento')==1
		// Salvar o conteúdo da variável.
		cBackUp := cU7_OPERAD
		// Atribuir a variável a seleção do usuário.
		cU7_OPERAD := "IN " + A110SelOpe() + " "
		// Se retornar vazio, reatribuir o back-up.
		If Empty( cU7_OPERAD ) 
			cU7_OPERAD := cBackUp
		Endif
		// Se o back-up for diferente da variável refazer os objetos.
		If cBackUp <> cU7_OPERAD
			cTRB := GetNextAlias()
			nCount := A110Lista(@cTRB)
			If nCount > 0
				aCOLS1 := {}
				aCOLS2 := {}
				aCOLS3 := {}
				
				A110Cols(cTRB)
				(cTRB)->(dbCloseArea())
				
				oGride1:SetArray( aCOLS1, .T. )
				oGride2:SetArray( aCOLS2, .T. )
				oGride3:SetArray( aCOLS3, .T. )
			   
				oGride1:Refresh()
				oGride2:Refresh()
				oGride3:Refresh()
			Endif
		Else
			MsgAlert('A seleção dos operadores não mudou.',cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110Detail | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o resumo do contato e da entidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Detail(nAba,oGride,oTLbx1,oTLbx2)
	Local aLista1 := {}
	Local aLista2 := {}
	
	Local cHeader := ''
	Local cDado   := ''
	Local cDFunc  := ''
	
	Local cPAB_DESC   := ''
	Local cU6_CONTATO := ''
	Local cU6_ENTIDA  := ''
	Local cU6_CODENT  := ''

	Local nI          := 0
	Local nItem       := 0
	Local nLines      := 0
	Local nU6_CONTATO := 0
	Local nU6_ENTIDA  := 0
	Local nU6_CODENT  := 0
	
	Local aCpoSU5 := {}
	Local aCpoSZT := {}
	Local aCpoSZX := {}
	Local aCpoSA1 := {}
	Local aCpoSUS := {}
	Local aCpoACH := {}
	Local aCpoPAB := {}
	
	//Retornar aba atual
	nAbaAtu := nAba
	
	nItem := oGride:nAt
	cHeader := 'aHeader'+LTrim(Str(nAba))
	
	nU6_CONTATO := AScan( &(cHeader), {|p| p[2]=='U6_CONTATO'} )
	nU6_ENTIDA  := AScan( &(cHeader), {|p| p[2]=='U6_ENTIDA' } )
	nU6_CODENT  := AScan( &(cHeader), {|p| p[2]=='U6_CODENT' } )
	
	cU6_CONTATO := oGride:aCOLS[ nItem, nU6_CONTATO ]
	cU6_ENTIDA  := oGride:aCOLS[ nItem, nU6_ENTIDA ]
	cU6_CODENT  := RTrim(oGride:aCOLS[ nItem, nU6_CODENT ])
	
	AAdd(aCpoSU5,{'U5_CODCONT',''})
	AAdd(aCpoSU5,{'U5_CONTAT' ,''})
	AAdd(aCpoSU5,{'U5_CPF'    ,''})
	AAdd(aCpoSU5,{'U5_DDD'    ,''})
	AAdd(aCpoSU5,{'U5_FONE'   ,''})
	AAdd(aCpoSU5,{'U5_CELULAR',''})
	AAdd(aCpoSU5,{'U5_FCOM1'  ,''})
	AAdd(aCpoSU5,{'U5_FCOM2'  ,''})
	AAdd(aCpoSU5,{'U5_EMAIL'  ,''})
	AAdd(aCpoSU5,{'U5_END'    ,''})
	AAdd(aCpoSU5,{'U5_BAIRRO' ,''})
	AAdd(aCpoSU5,{'U5_MUN'    ,''})
	AAdd(aCpoSU5,{'U5_EST'    ,''})
	AAdd(aCpoSU5,{'U5_FUNCAO' ,''})
	AAdd(aCpoSU5,{'U5_CONCORR',''})
	
	SX3->(dbSetOrder(2))
	For nI := 1 To Len(aCpoSU5)
		SX3->(dbSeek(aCpoSU5[nI,1]))
		aCpoSU5[nI,2] := SX3->X3_TITULO
	Next nI

	SU5->( dbSetOrder(1) )
	If SU5->( dbSeek( xFilial('SU5') + cU6_CONTATO ) )
		AAdd(aLista1,PadR('[ RESUMO DO CONTATO ]',78,'_'))
		For nI := 1 To Len(aCpoSU5)
			If ValType(SU5->(FieldGet(FieldPos(aCpoSU5[nI,1]))))=='D'
				cDado := Dtoc(SU5->(FieldGet(FieldPos(aCpoSU5[nI,1]))))
			Elseif ValType(SU5->(FieldGet(FieldPos(aCpoSU5[nI,1]))))=='N'
				cDado := LTrim(TransForm(SU5->(FieldGet(FieldPos(aCpoSU5[nI,1]))),'@E 999,999,999.99'))
			Else
				cDado := RTrim(SU5->(FieldGet(FieldPos(aCpoSU5[nI,1]))))
			Endif
			If aCpoSU5[nI,1] == 'U5_FUNCAO'
				If .NOT. Empty(cDado)
					cDFunc := Posicione('SUM',1,xFilial('SUM')+cDado,'UM_DESC')
					cDado  := cDado + ' - ' + cDFunc
				EndIF
				AAdd(aLista1,aCpoSU5[nI,2]+": "+cDado)
			Else
				AAdd(aLista1,aCpoSU5[nI,2]+": "+cDado)
			EndIF
		Next nI
	Else
		AAdd(aLista1,'Não localizado o registro do contato.')
	Endif
	
	If cU6_ENTIDA=='SZT'
		AAdd(aCpoSZT,{'ZT_CODIGO'  ,''})
		AAdd(aCpoSZT,{'ZT_EMPRESA' ,''})
		AAdd(aCpoSZT,{'ZT_CNPJ'    ,''})
		AAdd(aCpoSZT,{'ZT_COMMON'  ,''})
		AAdd(aCpoSZT,{'ZT_PRODUTO' ,''})
		AAdd(aCpoSZT,{'ZT_CONTTEC' ,''})
		AAdd(aCpoSZT,{'ZT_NOME'    ,''})
		AAdd(aCpoSZT,{'ZT_UF'      ,''})
		AAdd(aCpoSZT,{'ZT_ESTADO'  ,''})
		AAdd(aCpoSZT,{'ZT_FONE'    ,''})
		AAdd(aCpoSZT,{'ZT_DT_INC'  ,''})
		AAdd(aCpoSZT,{'ZT_DT_VLD'  ,''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoSZT)
			SX3->(dbSeek(aCpoSZT[nI,1]))
			aCpoSZT[nI,2] := SX3->X3_TITULO
		Next nI
		
		SZT->( dbSetOrder(1) )
		If SZT->( dbSeek( xFilial('SZT') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE COMMON NAME ]',78,'_'))
			
			For nI := 1 To Len(aCpoSZT)
				If ValType(SZT->(FieldGet(FieldPos(aCpoSZT[nI,1]))))=='D'
					cDado := Dtoc(SZT->(FieldGet(FieldPos(aCpoSZT[nI,1]))))
				Elseif ValType(SZT->(FieldGet(FieldPos(aCpoSZT[nI,1]))))=='N'
					cDado := LTrim(TransForm(SZT->(FieldGet(FieldPos(aCpoSZT[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(SZT->(FieldGet(FieldPos(aCpoSZT[nI,1]))))
				Endif
				AAdd(aLista2,aCpoSZT[nI,2]+": "+cDado)
			Next nI
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif
	Elseif cU6_ENTIDA=='SZX'
		AAdd(aCpoSZX,{'ZX_CODIGO'  ,''})
		AAdd(aCpoSZX,{'ZX_CDCPF'   ,''})
		AAdd(aCpoSZX,{'ZX_NMCLIEN' ,''})
		AAdd(aCpoSZX,{'ZX_DSEMAIL' ,''})
		AAdd(aCpoSZX,{'ZX_NRTELEF' ,''})
		AAdd(aCpoSZX,{'ZX_CDPRODU' ,''})
		AAdd(aCpoSZX,{'ZX_DSPRODU' ,''})
		AAdd(aCpoSZX,{'ZX_ICRENOV' ,''})
		AAdd(aCpoSZX,{'ZX_DTEMISS' ,''})
		AAdd(aCpoSZX,{'ZX_DTEXPIR' ,''})
		AAdd(aCpoSZX,{'ZX_DSCARGO' ,''})
		AAdd(aCpoSZX,{'ZX_NRCNPJ'  ,''})
		AAdd(aCpoSZX,{'ZX_DSRAZAO' ,''})
		AAdd(aCpoSZX,{'ZX_DSCARGO' ,''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoSZX)
			SX3->(dbSeek(aCpoSZX[nI,1]))
			aCpoSZX[nI,2] := SX3->X3_TITULO
		Next nI
		
		SZX->( dbSetOrder(1) )
		If SZX->( dbSeek( xFilial('SZX') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE ICP-BRASIL ]',78,'_'))
			For nI := 1 To Len(aCpoSZX)
				If ValType(SZX->(FieldGet(FieldPos(aCpoSZX[nI,1]))))=='D'
					cDado := Dtoc(SZX->(FieldGet(FieldPos(aCpoSZX[nI,1]))))
				Elseif ValType(SZX->(FieldGet(FieldPos(aCpoSZX[nI,1]))))=='N'
					cDado := LTrim(TransForm(SZX->(FieldGet(FieldPos(aCpoSZX[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(SZX->(FieldGet(FieldPos(aCpoSZX[nI,1]))))
				Endif
				AAdd(aLista2,aCpoSZX[nI,2]+": "+cDado)
			Next nI
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif
	Elseif cU6_ENTIDA=='SUS'
		AAdd(aCpoSUS,{'US_COD'  ,''})
		AAdd(aCpoSUS,{'US_LOJA' ,''})
		AAdd(aCpoSUS,{'US_NOME' ,''})
		AAdd(aCpoSUS,{'US_END'  ,''})
		AAdd(aCpoSUS,{'US_CEP'  ,''})
		AAdd(aCpoSUS,{'US_MUN'  ,''})
		AAdd(aCpoSUS,{'US_EST'  ,''})
		AAdd(aCpoSUS,{'US_DDD'  ,''})
		AAdd(aCpoSUS,{'US_TEL'  ,''})
		AAdd(aCpoSUS,{'US_EMAIL',''})
		AAdd(aCpoSUS,{'US_CGC'  ,''})
		AAdd(aCpoSUS,{'US_INSCR',''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoSUS)
			SX3->(dbSeek(aCpoSUS[nI,1]))
			aCpoSUS[nI,2] := SX3->X3_TITULO
		Next nI
		
		SUS->( dbSetOrder(1) )
		If SUS->( dbSeek( xFilial('SUS') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE PROSPECTS ]',78,'_'))
			For nI := 1 To Len(aCpoSUS)
				If ValType(SUS->(FieldGet(FieldPos(aCpoSUS[nI,1]))))=='D'
					cDado := Dtoc(SUS->(FieldGet(FieldPos(aCpoSUS[nI,1]))))
				Elseif ValType(SUS->(FieldGet(FieldPos(aCpoSUS[nI,1]))))=='N'
					cDado := LTrim(TransForm(SUS->(FieldGet(FieldPos(aCpoSUS[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(SUS->(FieldGet(FieldPos(aCpoSUS[nI,1]))))
				Endif
				AAdd(aLista2,aCpoSUS[nI,2]+": "+cDado)
			Next nI
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif
	Elseif cU6_ENTIDA=='ACH'
		AAdd(aCpoACH,{'ACH_CODIGO',''})
		AAdd(aCpoACH,{'ACH_LOJA'  ,''})
		AAdd(aCpoACH,{'ACH_RAZAO' ,''})
		AAdd(aCpoACH,{'ACH_END'   ,''})
		AAdd(aCpoACH,{'ACH_CEP'   ,''})
		AAdd(aCpoACH,{'ACH_CIDADE',''})
		AAdd(aCpoACH,{'ACH_EST'   ,''})
		AAdd(aCpoACH,{'ACH_DDD'   ,''})
		AAdd(aCpoACH,{'ACH_TEL'   ,''})
		AAdd(aCpoACH,{'ACH_EMAIL' ,''})
		AAdd(aCpoACH,{'ACH_CGC'   ,''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoACH)
			SX3->(dbSeek(aCpoACH[nI,1]))
			aCpoACH[nI,2] := SX3->X3_TITULO
		Next nI
		
		ACH->( dbSetOrder(1) )
		If ACH->( dbSeek( xFilial('SUS') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE SUSPECTS ]',78,'_'))
			For nI := 1 To Len(aCpoACH)
				If ValType(ACH->(FieldGet(FieldPos(aCpoACH[nI,1]))))=='D'
					cDado := Dtoc(ACH->(FieldGet(FieldPos(aCpoACH[nI,1]))))
				Elseif ValType(ACH->(FieldGet(FieldPos(aCpoACH[nI,1]))))=='N'
					cDado := LTrim(TransForm(ACH->(FieldGet(FieldPos(aCpoACH[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(ACH->(FieldGet(FieldPos(aCpoACH[nI,1]))))
				Endif
				AAdd(aLista2,aCpoACH[nI,2]+": "+cDado)
			Next nI
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif
	Elseif cU6_ENTIDA=='SA1'
		AAdd(aCpoSA1,{'A1_COD'  ,''})
		AAdd(aCpoSA1,{'A1_LOJA' ,''})
		AAdd(aCpoSA1,{'A1_NOME' ,''})
		AAdd(aCpoSA1,{'A1_END'  ,''})
		AAdd(aCpoSA1,{'A1_CEP'  ,''})
		AAdd(aCpoSA1,{'A1_MUN'  ,''})
		AAdd(aCpoSA1,{'A1_EST'  ,''})
		AAdd(aCpoSA1,{'A1_DDD'  ,''})
		AAdd(aCpoSA1,{'A1_TEL'  ,''})
		AAdd(aCpoSA1,{'A1_EMAIL',''})
		AAdd(aCpoSA1,{'A1_CGC'  ,''})
		AAdd(aCpoSA1,{'A1_INSCR',''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoSA1)
			SX3->(dbSeek(aCpoSA1[nI,1]))
			aCpoSA1[nI,2] := SX3->X3_TITULO
		Next nI
		
		SA1->( dbSetOrder(1) )
		If SA1->( dbSeek( xFilial('SA1') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE CLIENTES ]',78,'_'))
			For nI := 1 To Len(aCpoSA1)
				If ValType(SA1->(FieldGet(FieldPos(aCpoSA1[nI,1]))))=='D'
					cDado := Dtoc(SA1->(FieldGet(FieldPos(aCpoSA1[nI,1]))))
				Elseif ValType(SA1->(FieldGet(FieldPos(aCpoSA1[nI,1]))))=='N'
					cDado := LTrim(TransForm(SA1->(FieldGet(FieldPos(aCpoSA1[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(SA1->(FieldGet(FieldPos(aCpoSA1[nI,1]))))
				Endif
				AAdd(aLista2,aCpoSA1[nI,2]+": "+cDado)
			Next nI
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif
	Elseif cU6_ENTIDA=='PAB'
		AAdd(aCpoPAB,{'PAB_CODIGO' ,''})
		AAdd(aCpoPAB,{'PAB_NOME'   ,''})
		AAdd(aCpoPAB,{'PAB_CPF'    ,''})
		AAdd(aCpoPAB,{'PAB_EMAIL'  ,''})
		AAdd(aCpoPAB,{'PAB_DDD'    ,''})
		AAdd(aCpoPAB,{'PAB_TELEFO' ,''})
		AAdd(aCpoPAB,{'PAB_CELULA' ,''})
		AAdd(aCpoPAB,{'PAB_EMPRES' ,''})
		AAdd(aCpoPAB,{'PAB_CNPJ'   ,''})
		AAdd(aCpoPAB,{'PAB_CARGO'  ,''})
		AAdd(aCpoPAB,{'PAB_CONCOR' ,''})
		
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aCpoPAB)
			SX3->(dbSeek(aCpoPAB[nI,1]))
			aCpoPAB[nI,2] := SX3->X3_TITULO
		Next nI
		
		PAB->( dbSetOrder(1) )
		If PAB->( dbSeek( xFilial('PAB') + cU6_CODENT ) )
			AAdd(aLista2,PadR('[ RESUMO DA ENTIDADE LISTA DE CONTATOS ]',78,'_'))
			For nI := 1 To Len(aCpoPAB)
				If ValType(PAB->(FieldGet(FieldPos(aCpoPAB[nI,1]))))=='D'
					cDado := Dtoc(PAB->(FieldGet(FieldPos(aCpoPAB[nI,1]))))
				Elseif ValType(PAB->(FieldGet(FieldPos(aCpoPAB[nI,1]))))=='N'
					cDado := LTrim(TransForm(PAB->(FieldGet(FieldPos(aCpoPAB[nI,1]))),'@E 999,999,999.99'))
				Else
					cDado := RTrim(PAB->(FieldGet(FieldPos(aCpoPAB[nI,1]))))
				Endif
				
				AAdd(aLista2,aCpoPAB[nI,2]+": "+cDado)
			Next nI
		                                  
			//--------------------------------------------------------------------------------------------------------------
			// Se houver o campo MEMO (PAB_DESC) capturar o conteúdo dele, do contrário pegar o campo caractere (PAB_DESCR).
			//--------------------------------------------------------------------------------------------------------------
			If PAB->(FieldPos('PAB_DESC')) > 0
				If !Empty( PAB->PAB_DESC )
					nLines := MlCount( PAB->PAB_DESC, 60 )
					For nI := 1 To nLines
						cPAB_DESC := MemoLine( PAB->PAB_DESC, 60, nI )
						If nI == 1
							AAdd(aLista2,Posicione('SX3',2,'PAB_DESC','X3_TITULO')+": "+cPAB_DESC)
						Else
							AAdd(aLista2,Space(Len(SX3->X3_TITULO))+": "+cPAB_DESC)
						Endif
					Next nI
				Else
					AAdd(aLista2,Posicione('SX3',2,'PAB_DESCR','X3_TITULO')+": "+PAB->PAB_DESCR)
				Endif
			Else
				AAdd(aLista2,Posicione('SX3',2,'PAB_DESCR','X3_TITULO')+": "+PAB->PAB_DESCR)
			Endif
		Else
			AAdd(aLista2,'Não localizado o registro da entidade.')
		Endif

	Else
		AAdd(aLista2,'Rotina não adere a entidade desta agenda.')
	Endif
	
	oTLbx1:Reset()
	oTLbx1:SetArray(aLista1)

	oTLbx2:Reset()
	oTLbx2:SetArray(aLista2)
Return

//-----------------------------------------------------------------------
// Rotina | A110PesqAg | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para efetuar pesquisa nos dados da agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110PesqAg( oGride, nOpc, cSeek )
	Local nP := 0
	Local nBegin := 0
	Local nCount := 0
	Local nP_GD_GLOBAL := 0
	
	cSeek := Upper(AllTrim(cSeek))
	nBegin := Min( oGride:nAt + 1 , Len(oGride:aCOLS) )
	nCount := Len(oGride:aCOLS)
	
	If Left( cSeek, 1 ) <> '*'
		If oGride:aHeader[nOpc,8] == 'N'
			nP := AScan( oGride:aCOLS, {|p| AllTrim(Str(p[nOpc])) == cSeek }, nBegin, nCount )
		Elseif oGride:aHeader[nOpc,8] == 'D'
			nP := AScan( oGride:aCOLS, {|p| Dtoc(p[nOpc]) == cSeek }, nBegin, nCount )
		Else
			nP := AScan( oGride:aCOLS, {|p| cSeek $ AllTrim(p[nOpc]) }, nBegin, nCount )
		Endif
   Else
   	cSeek := SubStr( cSeek, 2 )
   	nP_GD_GLOBAL := AScan(oGride:aHeader,{|p| p[2]=='GD_GLOBAL'})
   	nP := AScan( oGride:aCOLS, {|p| cSeek $ p[nP_GD_GLOBAL] }, nBegin, nCount )
   Endif
   
	If nP > 0
		oGride:GoTo( nP )
		oGride:oBrowse:Refresh()
		oGride:oBrowse:SetFocus()
		If ValType(oGride:oBrowse:bChange) == "B"
			Eval(oGride:oBrowse:bChange)
		Endif
	Else
		Help(" ",1,"REGNOIS")
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110Contat | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para efetuar a visualização completa do contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Contat( nAba, oGride )
	Local cHeader     := ''
	Local cU6_CONTATO := ''

	Local nItem       := 0
	Local nU6_CONTATO := 0
	
	INCLUI := .F.
	ALTERA := .F.
		
	nItem := oGride:nAt
	cHeader := 'aHeader'+LTrim(Str(nAba))
	
	nU6_CONTATO := AScan( &(cHeader), {|p| p[2]=='U6_CONTATO'} )
	cU6_CONTATO := oGride:aCOLS[ nItem, nU6_CONTATO ]

	SU5->( dbSetOrder(1) )
	If SU5->( dbSeek( xFilial('SU5') + cU6_CONTATO ) )
		A70Visual('SU5',SU5->(RecNo()),2)
	Else
		MsgAlert('Não localizei o registro do contato',cCadastro)
	Endif
	oGride:oBrowse:SetFocus()
Return

//-----------------------------------------------------------------------
// Rotina | A110Contat | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para efetuar a visualização completa do contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Entida( nAba, oGride )
	Local cU6_ENTIDA  := ''
	Local cU6_CODENT  := ''

	Local nItem := 0
	Local nU6_ENTIDA := 0
	Local nU6_CODENT := 0
	
	Private aRotina := {}
	
	AAdd(aRotina,{'','',0,1})
	AAdd(aRotina,{'','',0,2})
	AAdd(aRotina,{'','',0,3})
	AAdd(aRotina,{'','',0,4})
	AAdd(aRotina,{'','',0,5})
	
	nItem := oGride:nAt
	cHeader := 'aHeader'+LTrim(Str(nAba))
	
	nU6_ENTIDA  := AScan( &(cHeader), {|p| p[2]=='U6_ENTIDA' } )
	nU6_CODENT  := AScan( &(cHeader), {|p| p[2]=='U6_CODENT' } )
	
	cU6_ENTIDA  := oGride:aCOLS[ nItem, nU6_ENTIDA ]
	cU6_CODENT  := RTrim(oGride:aCOLS[ nItem, nU6_CODENT ])
	
	If !Empty(cU6_ENTIDA) .And. !Empty(cU6_CODENT)
		&(cU6_ENTIDA)->( dbSetOrder(1) )
		If &(cU6_ENTIDA)->( dbSeek( xFilial(cU6_ENTIDA) + cU6_CODENT ) )
			AxVisual(cU6_ENTIDA,&(cU6_ENTIDA)->(RecNo()),2)
		Else
			MsgAlert('Não localizei o registro da entidade',cCadastro)
		Endif
	Else
		MsgAlert('Não há entidade para visualizar.',cCadastro)
	Endif
	oGride:oBrowse:SetFocus()
Return

//-----------------------------------------------------------------------
// Rotina | A110Reagen | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para reagendar a atividade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Reagen(oGride)
	Local aPar := {}
	Local aRet := {}
	
	Local bOK := {|| Iif(A110VlReag(oGride,aRet),MsgYesNo('Confirma o reagendamento?',cCadastro),.F.) }
	
	Local nU4_OPERAD := 0
	Local nU4_RECNO  := 0
	Local nU4_STATUS:= 0
	
	Private dU4_DATA := ''
	Private cU4_HORA1 := ''
	
	Private nLinGd    := 0
	Private nU4_DATA  := 0
	Private nU4_HORA1 := 0
	
	If A110IsDel(oGride)
		Return
	Endif

	nLinGd := oGride:nAt
	nU4_DATA   := AScan(oGride:aHeader,{|p| p[2]=='U4_DATA'})
	nU4_HORA1  := AScan(oGride:aHeader,{|p| p[2]=='U4_HORA1'})
	nU4_RECNO  := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
	
	dU4_DATA  := oGride:aCOLS[nLinGd,nU4_DATA]
	cU4_HORA1 := oGride:aCOLS[nLinGd,nU4_HORA1]
	nU4_RECNO := oGride:aCOLS[nLinGd,nU4_RECNO]
	
	If dU4_DATA <> Ctod(Space(8)) .And. !Empty(cU4_HORA1) .And. nU4_RECNO > 0
		AAdd(aPar,{1,'Data do reagendamento',dU4_DATA ,'','','','',50,.T.})
		AAdd(aPar,{1,'Hora do reagendamento',cU4_HORA1,'@R 99:99:99','','','',50,.T.})
		If ParamBox(aPar,'Reagendamento',@aRet,bOK,,,,,,,.F.,.F.)
			
			// Preencher os zeros dos segundos.
			If Len(RTrim(aRet[2])) < 8
				aRet[2] := PadR(RTrim(aRet[2]),8,"0")
			Endif
			
			nU4_STATUS := AScan(oGride:aHeader,{|p| p[2]=='U4_STATUS'})
			
			If oGride:aCOLS[nLinGd,nU4_DATA] <> aRet[1]
				oGride:aCOLS[nLinGd,nU4_DATA] := aRet[1]
				aCOLS1[nLinGd,nU4_DATA] := aRet[1]
			Endif
			
			If oGride:aCOLS[nLinGd,nU4_HORA1] <> aRet[2]
				oGride:aCOLS[nLinGd,nU4_HORA1] := aRet[2]
				aCOLS1[nLinGd,nU4_HORA1] := aRet[2]
			Endif
					
			// ordenação do vetor.
			// supervisor
			// 	ordem1 => data + hora1 + operad + status
			// 	ordem2 => operad + data + hora1 + status
			// consultor
			// 	ordem1 => data + hora1 + status
					
			//é supervisor?
			If cU7_TIPO=='2'
				nU4_OPERAD := AScan(oGride:aHeader,{|p| p[2]=='U4_OPERAD'})
				//é ordem 1
				If nOrdemQry==1
					ASort(oGride:aCOLS,,,{|a,b| Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_OPERAD]+a[nU4_STATUS] < Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_OPERAD]+b[nU4_STATUS] })
					ASort(aCOLS1      ,,,{|a,b| Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_OPERAD]+a[nU4_STATUS] < Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_OPERAD]+b[nU4_STATUS] })
				//não é ordem 1.
				Elseif nOrdemQry==2
					ASort(oGride:aCOLS,,,{|a,b| a[nU4_OPERAD]+Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_STATUS] < b[nU4_OPERAD]+Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_STATUS] })
					ASort(aCOLS1      ,,,{|a,b| a[nU4_OPERAD]+Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_STATUS] < b[nU4_OPERAD]+Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_STATUS] })
				Endif
			//não é supervisor.
			Else
				ASort(oGride:aCOLS,,,{|a,b| Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_STATUS] < Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_STATUS] })
				ASort(aCOLS1      ,,,{|a,b| Dtos(a[nU4_DATA])+a[nU4_HORA1]+a[nU4_STATUS] < Dtos(b[nU4_DATA])+b[nU4_HORA1]+b[nU4_STATUS] })
			Endif
			SU4->(dbGoTo(nU4_RECNO))
			If nU4_RECNO == SU4->(RecNo())
				SU4->(RecLock('SU4',.F.))
				If SU4->U4_DATA <> aRet[1]
					SU4->U4_DATA := aRet[1]
				Endif
				If SU4->U4_HORA1 <> aRet[2]
					SU4->U4_HORA1 := aRet[2]
				Endif
				SU4->(MsUnLock())
				MsgInfo('Reagendamento efetuado com sucesso.',cCadastro)
			Endif
		Endif
		oGride:oBrowse:SetFocus()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110VlReag | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar o reagendamento informado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110VlReag(oGride,aRet)
	Local lRet := .F.
	Local cHrIni := '08:00:00'
	Local cHrFim := '20:00:00'
	Local cTime := Time()
	
	aRet[2] := TransForm(aRet[2],'@R 99:99:99')
	
	//-----------------------------------------------------------------
	// A data do reagendamento informado é maior ou igual a data atual?
	//-----------------------------------------------------------------
	If aRet[1] >= MsDate()
		//---------------------------------------------------------------------------------------
		// A data do reagendamento informado é igual a data atual?  Então validar somente a hora.
		//---------------------------------------------------------------------------------------
		If aRet[1] == MsDate()
			//----------------------------------------------------------------------
			// A hora informada é maior que a hora atual e menor que o limite final?
			//----------------------------------------------------------------------
			If aRet[2] > cTime .And. aRet[2] < cHrFim
				lRet := .T.
			Else
				MsgInfo('A hora do reagendamento informado não pode ser menor que a hora atual '+cTime+', e nem maior que '+cHrFim+' reavalie.',cCadastro)
			Endif	
		Else
			//-------------------------------------------------------------------------------------------------------------------------------------------
			// A data do reagendamento sendo maior que a data atual, validar se a hora do reagendamento informado é maior que os limites inicial e final.
			//-------------------------------------------------------------------------------------------------------------------------------------------
			If aRet[2] >= cHrIni .And. aRet[2] <= cHrFim
				lRet := .T.
			Else
				MsgInfo('A hora do reagendamento informado não pode ser menor que '+cHrIni+', e nem maior que '+cHrFim+' reavalie.',cCadastro)
			Endif
		Endif
	Else
		MsgInfo('A data do reagendamento não pode ser menor que a data de hoje, reavalie.',cCadastro)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Transf | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para transferir de operador a atividade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Transf(nAba,oGride)
	Local aPar := {}
	Local aRet := {}
	Local bOK  := {|| Iif(A110VlTran(oGride,aRet),MsgYesNo('Confirma a transferência?',cCadastro),.F.) }
	//Renato Ruy - 28/07/2016
	//Gerar historico de transferencia.
	Local nU4_LISTA  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_LISTA'	  } ) ]
	Local nU4_DESC  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_DESC'	  } ) ]
	Local nU6_ENTIDA  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U6_ENTIDA'	  } ) ]
	Local cU4_OPERAD := ''
	Local nU4_OPERAD := 0
	Local nU4_RECNO := 0
	Local nLinGd := 0
	Local cCOLS := 'aCOLS'+LTrim(Str(nAba))
	Local aInfo := {}

	If A110IsDel(oGride)
		Return
	Endif

	nLinGd := oGride:nAt 
	nU4_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
	nU4_RECNO := oGride:aCOLS[nLinGd,nU4_RECNO]
	
	If cU7_TIPO=='2'
		nU4_OPERAD := AScan(oGride:aHeader,{|p| p[2]=='U4_OPERAD'})			
		cU4_OPERAD := oGride:aCOLS[nLinGd,nU4_OPERAD]
	Else
		cU4_OPERAD := cU7_COD
	Endif

	If !Empty(cU4_OPERAD)
		AAdd(aPar,{1,'Transferir para',cU4_OPERAD ,'','','SU7','',50,.T.})
		If ParamBox(aPar,'Transferência de agenda',@aRet,bOK,,,,,,,.F.,.F.)
			ADel( &(cCOLS), nLinGd )
			ASize( &(cCOLS), Len( &(cCOLS) )-1 )
			
			oGride:SetArray( &(cCOLS) )
			oGride:ForceRefresh()
			
			//Renato Ruy - 28/07/2016
			//Grava na tabela de historicos
			DbSelectArea("ZZT")
			ZZT->(RecLock("ZZT",.T.))
				ZZT->ZZT_FILIAL	 := xFilial("ZZT")
				ZZT->ZZT_COD	 := nU4_LISTA
				ZZT->ZZT_RESP 	 := Posicione("SU7",4,xFilial( 'SU7' ) + __cUserID,"U7_COD")
				ZZT->ZZT_DATA  	 := dDataBase
				ZZT->ZZT_ATUAL	 := cU4_OPERAD
				ZZT->ZZT_DEST	 := aRet[1]
			ZZT->(MsUnlock())
			
		    //Monta dados para envio do aviso.
			AADD(aInfo,"Alterado por: "+Posicione("SU7",4,xFilial( 'SU7' ) + __cUserID,"U7_NOME"))
			AADD(aInfo,"Data: " + DtoC(dDataBase))
			AADD(aInfo,"Tipo da Lista: " + nU6_ENTIDA)
			AADD(aInfo,"Nome da Lista: " + nU4_DESC)
			AADD(aInfo,"Analista Atual: " + Posicione("SU7",1,xFilial( 'SU7' ) + cU4_OPERAD,"U7_NOME"))
			AADD(aInfo,"Analista Destino: " + Posicione("SU7",1,xFilial( 'SU7' ) + aRet[1],"U7_NOME"))
			
			//Chama a rotina que faz o envio.
			U_CSFA115("Transferência Lista: "+nU4_LISTA,"MV_XAGETF",aInfo)
			
			SU4->(dbGoTo(nU4_RECNO))
			If nU4_RECNO == SU4->(RecNo())
				SU4->(RecLock('SU4',.F.))
				SU4->U4_OPERAD := aRet[1]
				SU4->(MsUnLock())
				MsgInfo('Transferência efetuada com sucesso.',cCadastro)
			Endif
		Endif
	Else
		MsgAlert('Transferência não poderá ser feita, pois não há agenda.',cCadastro)
	Endif
	oGride:oBrowse:SetFocus()
Return

//-----------------------------------------------------------------------
// Rotina | A110VlTran | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar a transferência entre operadores.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110VlTran(oGride,aRet)
	Local lRet := .T.
	Local nLinGd := 0
	Local nU4_OPERAD := 0
	Local cU4_OPERAD := ''
	
	nLinGd := oGride:nAt

	If cU7_TIPO=='2'
		nU4_OPERAD := AScan(oGride:aHeader,{|p| p[2]=='U4_OPERAD'})			
		cU4_OPERAD := oGride:aCOLS[nLinGd,nU4_OPERAD]
	Else
		cU4_OPERAD := cU7_COD
	Endif
	
	If cU4_OPERAD == aRet[1]
		MsgInfo('A transferência deverá ser efetuada para outro operadore/consultore.',cCadastro)
		lRet := .F.
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Client | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de clientes.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Client()
	A110View("SA1","Cadastro de Clientes Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110Prod   | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de produtos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Prod()
	A110View("SB1","Cadastro de Produtos Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110SU5    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de contatos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SU5()
	A110View("SU5","Cadastro de Contatos Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110SZT    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de common-name.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SZT()
	A110View("SZT","Cadastro de Common Name Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110SZT    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de icp-brasil.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SZX()
	A110View("SZX","Cadastro de ICP-Brasil Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110PAB    | Autor | Robson Gonçalves     | Data | 17.05.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de lista de contatos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110PAB()
	A110View("PAB","Lista de contatos Certisign")
Return

//-----------------------------------------------------------------------
// Rotina | A110SUS    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de prospects.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SUS()
	A110View("SUS","Cadastro de Prospects")
Return

//-----------------------------------------------------------------------
// Rotina | A110ACH    | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar o cadastro de suspects.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110ACH()
	A110View("ACH","Cadastro de Suspects")
Return

//-----------------------------------------------------------------------
// Rotina | A110View   | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar dados conforme o cadastro da entidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110View(cAlias,cTitulo)
	Local cMV_110VIEW := 'MV_110VIEW'
	If .NOT. SX6->( ExisteSX6( cMV_110VIEW ) )
		CriarSX6( cMV_110VIEW, 'L', 'HABILITA FWMBROWSE NAS CONSULTAS DE CADASTROS DA  AGENDA CERTISIGN - CSFA110.prw', '.F.' )
	Endif
	If GetMv( cMV_110VIEW )
		A110SeeNew( cAlias, cTitulo )
	Else
		A110SeeOld( cAlias, cTitulo )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110SeeOld | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar dados conforme o cadastro da entidade.
//        | Modelo MaWndBrowse.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SeeOld( cAlias, cTitulo )
	Local nModelo := 2
	Local lCentered := .T.
	Local lPesq := .F.
	Local bViewReg
	Local cFunc := ''
	Private aRotina := {}
	Private cCadastro := cTitulo
	
	AAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	
	If cAlias == "SU5"
		INCLUI := .F.
		ALTERA := .F.
		cFunc := "A70Visual"
	Else
		cFunc := "AxVisual"
	Endif
	
	AAdd(aRotina,{"Visualizar",cFunc,0,2})
	
	If cAlias == 'SA1'
		AAdd(aRotina,{'Posição','A450F4CON',0,6})
	Endif
	
	If cAlias == 'SB1'
		AAdd(aRotina,{'Posição','MC050Con',0,6})
	Endif
	
	bViewReg := &("{|| "+aRotina[2,2]+"('"+cAlias+"',RecNo(),"+LTrim(Str(aRotina[2,4]))+")}")
	MaWndBrowse(,,,,cTitulo,cAlias,,aRotina,,,,lCentered,,nModelo,,,,,,lPesq,bViewReg)	
Return

//-----------------------------------------------------------------------
// Rotina | A110SeeNew | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar dados conforme o cadastro da entidade.
//        | Modelo FwMBrowse.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SeeNew( cAlias, cTitulo )
	Local oPnl
	Local oWind
	Local oBrw
	Local nLin2 := oMainWnd:nClientHeight - 34
	Local nCol2 := oMainWnd:nClientWidth - 14
	
	Private aRotina := {}
	
	AAdd( aRotina, {'Pesquisar', 'AxPesqui', 0, 1 } )
	AAdd( aRotina, {'Visualizar', Iif(cAlias=='SU5','A70Visual','AxVisual'), 0, 2 } )

	If cAlias $ 'SA1|SB1'
		AAdd( aRotina, {'Posição', Iif(cAlias=='SA1','A450F4CON','MC050Con'), 0, 6 } )
	Endif
	
	//Renato Ruy - 12/08/16
	//Pesquisa dados do ultimo atendente.
	If cAlias $ 'SA1
		AAdd( aRotina, {'Rastrear', 'U_CSFA110R', 0, 7 } )
	Endif
	
	cMV_110DIM := GetMv('MV_110DIM')

	If cMV_110DIM == '0'
		DEFINE MSDIALOG oWind TITLE '' FROM 190,250 TO nLin2,nCol2 OF oMainWnd PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oWind:lEscClose := .F.
			oPnl := TPanel():New(0,0,,oWind,,,,,RGB(116,116,116),1,1000,.F.,.F.)
			oPnl:Align := CONTROL_ALIGN_ALLCLIENT
			oBrw := FwMbrowse():New()
			oBrw:SetAlias( cAlias )
			oBrw:SetOwner( oPnl )
			oBrw:SetDescription( cTitulo )
			oBrw:DisableDetails()
			oBrw:DisableConfig()
			oBrw:DisableLocate()
			oBrw:DisableSaveConfig()
			oBrw:DisableReport()
			oBrw:SetWalkThru( .F. )
			oBrw:SetAmbiente( .F. )
			oBrw:ForceQuitButton()
			oBrw:Activate()
		ACTIVATE MSDIALOG oWind CENTERED ON INIT (oBrw:Refresh())
	Else
		oBrw := FwMbrowse():New()
		oBrw:SetAlias( cAlias )
		oBrw:SetOwner( oPnl )
		oBrw:SetDescription( cTitulo )
		oBrw:DisableDetails()
		oBrw:DisableConfig()
		oBrw:DisableLocate()
		oBrw:DisableSaveConfig()
		oBrw:DisableReport()
		oBrw:SetWalkThru( .F. )
		oBrw:SetAmbiente( .F. )
		oBrw:Activate()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110TabPre | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar dados da tabela de preço.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110TabPre()
	Local aPar := {}
	Local aRet := {}
	Local aArea := {}
	Local aAreaDA0 := {}	
	Private aRotina := {}
	AAdd( aPar,{1,'Tabela de preço',Space(Len(DA0->DA0_CODTAB)),"","ExistCpo('DA0')","DA0","",0,.T.})
	If ParamBox(aPar,'Selecione a tabela de preço',@aRet,,,,,,,,.F.,.F.)
		aArea := GetArea()
		aAreaDA0 := DA0->(GetArea())
		If DA0->(dbSeek(xFilial("DA0")+aRet[1]))
			INCLUI := .F.
			ALTERA := .F.
			
			aRotina := {{'','',0,1},;
			            {'','',0,2},;
			            {'','',0,3},;
			            {'','',0,4},;
			            {'','',0,5}}
			            
			Oms010Tab("DA0",DA0->(Recno()),2)
		Else
			MsgInfo('Tabela de preço não localizada.',cCadastro)
		Endif
		DA0->(Restarea(aAreaDA0))
		RestArea(aArea)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110Indic  | Autor | Robson Gonçalves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar os indicadores da agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Indic()
	Local oDlg 
	Local oBmp
	Local oFnt
	Local oBtn
	
	Local aTexto := {}
	
	Local bGet := {|| .T. }
	
	Local cSay := ''
	Local cPICT := '@E 999,999'
	Local cTexto1 := 'Agendas para hoje : '
	Local cTexto2 := 'Agendas atendidas : ' 
	Local cTexto3 := 'Agendas futuras   : '

	Local nLin := 5
	Local nDel1 := 0
	Local nDel2 := 0
	Local nDel3 := 0
	Local nCOLS1 := 0
	Local nCOLS2 := 0
	Local nCOLS3 := 0
	
	oFnt := TFont():New( "Courier New",,-12)
	
	//--------------------------------------------
	// Capturar a posição da colunação de deleção.
	//--------------------------------------------
	nDel1 := Len(oGride1:aCOLS[1])
	nDel2 := Len(oGride2:aCOLS[1])
	nDel3 := Len(oGride3:aCOLS[1])

	//-----------------------------------------------------------------------------------------
	// Efetuar a contagem de elementos no vetor desconsiderando o elemento deletado se existir.
	//-----------------------------------------------------------------------------------------
	AEval( oGride1:aCOLS, {|p| nCOLS1 += Iif(!p[nDel1],1,0) } )
	AEval( oGride2:aCOLS, {|p| nCOLS2 += Iif(!p[nDel2],1,0) } )
	AEval( oGride3:aCOLS, {|p| nCOLS3 += Iif(!p[nDel3],1,0) } )

	//--------------------------------------------------------------------------------------------------------------------------------
	// Caso haja somente um elemento, verificar se há conteúdo, pois pode não haver e assim não considerar como contador no indicador.
	//--------------------------------------------------------------------------------------------------------------------------------
	If nCOLS1 == 1
		If Empty(oGride1:aCOLS[1,2])
			nCOLS1 := 0
		Endif
	Endif
	If nCOLS2 == 1
		If Empty(oGride2:aCOLS[1,2])
			nCOLS2 := 0
		Endif
	Endif
	If nCOLS3 == 1
		If Empty(oGride3:aCOLS[1,2])
			nCOLS3 := 0
		Endif
	Endif
	
	//----------------------------------
	// Montar o texto a ser apresentado.
	//----------------------------------
	AAdd(aTexto,{cTexto1,nCOLS1})
	AAdd(aTexto,{cTexto2,nCOLS2})
	AAdd(aTexto,{cTexto3,nCOLS3})
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 180,400 TITLE 'Indicador de Agenda' OF oDlg PIXEL
		@ 0,0 BITMAP oBmp RESNAME 'BSPESQUI.PNG' oF oDlg SIZE 70,200 NOBORDER WHEN .F. PIXEL
		For nI := 1 To Len( aTexto )
			If nI <= 8
			   cSay := aTexto[nI,1] + LTrim(TransForm(aTexto[nI,2],cPICT))
			   bGet := &("{|| '"+cSay+"'}")
				TSay():New(nLin,65,bGet,oDlg,,oFnt,.F.,.F.,.F.,.T.,CLR_BLUE,,GetTextWidth(0,cSay),15,.F.,.F.,.F.,.F.,.F.)
				nLin += 10
			Endif
		Next nI
		oBtn := TButton():New(75,166,'Voltar',oDlg,{|| oDlg:End() },32,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//-----------------------------------------------------------------------
// Rotina | A110LoadAg   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para recarregar os dados dos aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110LoadAg( nFilAgenda, nFilEntida, dExpirDe, dExpirAte, cContato, cEmpresa, nNomLista, cContem, nPriori )
	Local cTRB := ''
	Local cAcao := ''
	Local cPasta := ''
	
	Local nP := 0
	Local nDel1 := 0
	Local nDel3 := 0	
	Local nPos1 := 0
	Local nPos3 := 0
	Local nCount := 0
	
	Local lContinua := .T.
	
	DEFAULT nFilAgenda := a110Fil[ 1 ]
	DEFAULT nFilEntida := a110Fil[ 2 ]
	DEFAULT dExpirDe   := a110Fil[ 3 ]
	DEFAULT dExpirAte  := a110Fil[ 4 ]
	DEFAULT cContato   := a110Fil[ 5 ]
	DEFAULT cEmpresa   := a110Fil[ 6 ]
	DEFAULT nNomLista  := a110Fil[ 7 ]
	DEFAULT cContem    := a110Fil[ 8 ]
	DEFAULT nPriori    := a110Fil[ 9 ]
	
	nDel1 := Len(oGride1:aCOLS[1])
	nDel3 := Len(oGride3:aCOLS[1])

	nPos1 := AScan( oGride1:aCOLS, {|p| p[nDel1]==.T.})
	nPos3 := AScan( oGride3:aCOLS, {|p| p[nDel3]==.T.})
	
	cPasta := Iif(nPos1>0,'para hoje','futuras')
	cAcao  := Iif(nFilAgenda==0 ;
	          .Or.nFilEntida>0  ;
	          .Or..NOT.Empty(dExpirDe);
	          .Or..NOT.Empty(dExpirAte);
	          .Or..NOT.Empty(cContato);
	          .Or..NOT.Empty(cEmpresa),'atualizar','filtrar')
	
	If nPos1 > 0 .Or. nPos3 > 0
		If ! MsgYesNo('Na pasta de agendas '+cPasta+' há item(ns) atendidos, ou seja, na cor cinza.'+CRLF+;
		              'Se prosseguir com o '+cAcao+' não será possível cancelar o atendimento.'+CRLF+;
		              'Prosseguir com o '+cAcao+'?',cCadastro)
			lContinua := .F.
		Endif	
	Endif
	
	If lContinua 
		cTRB := GetNextAlias()
		nCount := A110Lista( @cTRB, nFilAgenda, nFilEntida, dExpirDe, dExpirAte, cContato, cEmpresa, nNomLista, cContem, nPriori )
		If nCount > 0
			aCOLS1 := {}
			aCOLS2 := {}
			aCOLS3 := {}
			
			MsgRun('Aguarde, recarregando os dados...',cCadastro,;
			{|| A110Cols(cTRB),;
			(cTRB)->(dbCloseArea()),;
			oGride1:SetArray( aCOLS1, .T. ),;
			oGride2:SetArray( aCOLS2, .T. ),;
			oGride3:SetArray( aCOLS3, .T. ),;
			oGride1:Refresh(),;
			oGride2:Refresh(),;
			oGride3:Refresh(),;
			Eval( oGride1:bChange ) })
		Endif
	Endif
Return(lContinua)

//-----------------------------------------------------------------------
// Rotina | A110Telefo   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ o operador efetuar a ligação e logo o atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
/*
U4_STATUS -> 1=Ativa;2=Encerrada;3=Em andamento.
U6_STATUS -> 1=Não enviado;2=Em uso;3=Enviado.

Quando é atendido SEM retorno   -> a) somente dá baixa -> U4_STATUS = '2' .And. U6_STATUS = '3' e gerar SUC/SUD.

Quando é atendido COM retorno   -> a) efetuar baixa    -> U4_STATUS = '2' .And. U6_STATUS = '3' e gerou SUC/SUD, porém guardar UC_CODIGO.
                                   b) gera-se uma nova lista de atendimento (SU4/SU6) com os campos U4_CODLIG/U6_CODLIG iguais ao nº de atendimento UC_CODIGO.
                                   c) quando for atender os dados devem ser gerados no atendimento origem, no caso UC_CODIGO==U4_CODLIG. 
                                   d) o U6_ORIGEM deve ser igual a 3=Atendimento. atenção com o campo U4_FORMA que está igual a 5=Pendencia.
*/
Static Function A110Telefo(nAba,oGride)
	Local lRet        := .T.
	Local cHeader     := ''
	Local cDisk       := ''
	Local cTEL        := ''
	Local cU4_LISTA   := ''
	Local cU6_CONTATO := ''
	Local cU6_ENTIDA  := ''
	Local cU6_CODENT  := ''
	Local cMV_TSDISCA := 'MV_TSDISCA'
	
	Local nI          := 0
	Local nOpcA       := 0
	Local nOpcB       := 0
	Local nItem       := 0
	Local nU6_LISTA   := 0
	Local nU6_CONTAT  := 0
	Local nU6_ENTIDA  := 0
	Local nU6_CODENT  := 0
	
	Local aRet := Array(1)
	Local aPar := {}
	Local aTEL := {}
	
	Private cUC_XDIPROP := ""
	Private cUC_XHIPROP := ""
	
	If A110IsDel(oGride)
		Return
	Endif
	
	If .NOT. GetMv( cMV_TSDISCA, .T. )
		CriarSX6( cMV_TSDISCA, 'C', 'HABILITA INTERFACE DE STATUS DE DISCAGEM NA AGENDA DO OPERADOR CERTISIGN. S=SIM E N=NAO', 'N' )
	Endif
	
	cMV_TSDISCA := GetMv( 'MV_TSDISCA', .F. )
	
	nItem := oGride:nAt
	cHeader := 'aHeader'+LTrim(Str(nAba))
	
	nU4_LISTA   := AScan( &(cHeader), {|p| p[2]=='U4_LISTA'} )
	nU6_CONTATO := AScan( &(cHeader), {|p| p[2]=='U6_CONTATO'} )
	nU6_ENTIDA  := AScan( &(cHeader), {|p| p[2]=='U6_ENTIDA' } )
	nU6_CODENT  := AScan( &(cHeader), {|p| p[2]=='U6_CODENT' } )
	
	cU4_LISTA   := oGride:aCOLS[ nItem, nU4_LISTA ]
	cU6_CONTATO := oGride:aCOLS[ nItem, nU6_CONTATO ]
	cU6_ENTIDA  := oGride:aCOLS[ nItem, nU6_ENTIDA ]
	cU6_CODENT  := RTrim(oGride:aCOLS[ nItem, nU6_CODENT ])
	
	//----------------------------------------
	// Capturar todos os telefones do contato.
	//----------------------------------------
	aTEL := SU5->(GetAdvFVal('SU5',{'U5_DDD','U5_FONE','U5_CELULAR','U5_FCOM1','U5_FCOM2'},xFilial('SU5')+cU6_CONTATO,1))
	
	//--------------------------------------
	// Montar os dados em um única variável.
	//--------------------------------------
	For nI := 1 To Len( aTEL )
		If !Empty(aTEL[nI])
			If !(RTrim(aTEL[nI]) $ cTEL)
				cTEL += RTrim(aTEL[nI])+'-'
			Endif
		Endif
	Next nI
	
	If !Empty(cTEL)
		cTEL := SubStr(cTEL,1,Len(cTEL)-1)
	Endif
	
	//-----------------------------------------------------------------------------------------
	// Caso não haja telefone do contato, capturar na lista de telefone relacionado ao contato.
	//-----------------------------------------------------------------------------------------
	If Empty(cTEL)
		ACH->(dbSetOrder(1))
		ACH->(dbSeek(xFilial('ACH')+'SU5'+cU6_CONTATO))
		While ! ACH->(EOF()) .And. SU5->(U5_FILIAL+U5_CODCONT)==xFilial('SU5')+cU6_CONTATO
			If !Empty(ACH->ACH_DDD)
				cTEL += ACH->ACH_DDD + '-'
			Endif
			If !Empty(ACH->ACH_TELEFO)
				cTEL += RTrim(ACH->ACH_TELEFO) + '/'
			Endif
			ACH->(dbSkip())
		End
		If !Empty(cTEL)
			cTEL := SubStr(cTEL,1,Len(cTEL)-1)
		Endif
	Endif
	
	//----------------------------------------------------------------------
	// Caso não haja telefone na relação, capturar o telefone nas entidades.
	//----------------------------------------------------------------------
	If Empty(cTEL)
		If cU6_ENTIDA == 'SZT'
			cTEL := RTrim((cU6_ENTIDA)->(Posicione(cU6_ENTIDA,1,xFilial(cU6_ENTIDA)+cU6_CODENT,'ZT_FONE')))
		Elseif cU6_ENTIDA == 'SZX'
			cTEL := RTrim((cU6_ENTIDA)->(Posicione(cU6_ENTIDA,1,xFilial(cU6_ENTIDA)+cU6_CODENT,'ZX_NRTELEF')))
		Elseif cU6_ENTIDA == 'SUS'
			aTEL := SUS->(GetAdvFVal(cU6_ENTIDA,{'US_DDD','US_TEL'},xFilial(cU6_ENTIDA)+cU6_CODENT,1))
			cTEL := Iif(Empty(aTEL[1]),'',aTEL[1]+' ')+RTrim(aTEL[2])
		Elseif cU6_ENTIDA == 'ACH'
			aTEL := ACH->(GetAdvFVal(cU6_ENTIDA,{'ACH_DDD','ACH_TEL'},xFilial(cU6_ENTIDA)+cU6_CODENT,1))
			cTEL := Iif(Empty(aTEL[1]),'',aTEL[1]+' ')+RTrim(aTEL[2])
		Elseif cU6_ENTIDA == 'SA1'
			aTEL := SA1->(GetAdvFVal(cU6_ENTIDA,{'A1_DDD','A1_TEL'},xFilial(cU6_ENTIDA)+cU6_CODENT,1))
			cTEL := Iif(Empty(aTEL[1]),'',aTEL[1]+' ')+RTrim(aTEL[2])
		Elseif cU6_ENTIDA == 'PAB'
			aTEL := PAB->(GetAdvFVal(cU6_ENTIDA,{'PAB_DDD','PAB_TELEFO','PAB_CELULA'},xFilial(cU6_ENTIDA)+cU6_CODENT,1))
			cTEL := Iif(Empty(aTEL[1]),'',aTEL[1]+' ')+Iif(Empty(aTEL[2]),'',aTEL[2]+' ')+Iif(Empty(aTEL[3]),'',aTEL[3]+' ')
		Else
			lRet := .F.
			MsgAlert('Rotina não adere a entidade em questão.',cCadastro)
		Endif
	Endif
	
	If lRet
		//---------------------------------------------------------------------------------------
		// Caso não haja telefone em nenhuma das alternativas acima, capture o e-mail do contato.
		//---------------------------------------------------------------------------------------
		If Empty(cTEL)
			cTEL := RTrim(SU5->(Posicione('SU5',1,xFilial('SU5')+cU6_CONTATO,'U5_EMAIL')))
			//---------------------------------------------------------------------------
			// Caso não telefone e nem e-mail, será que o usuário consegue fazer contato?
			//---------------------------------------------------------------------------
			If Empty(cTEL)
				cDisk := 'Não localizei o número do telefone e nem e-mail. Há possibilidade de fazer contato?'
			Else
				cDisk := 'Não localizei o número do telefone, faça contato pelo e-mail: '+cTEL+CRLF
			Endif
		Else
			cDisk := 'Disque para o número a seguir: '+cTEL+CRLF
		Endif
		If ! Empty(cDisk)
			cDisk := cDisk +'Confirma o sucesso da chamada?'
		Endif
		nOpcA := Aviso(cCadastro,cDisk,{'Sim','Não','Abandonar'},2,'Ao fazer contato')
		If nOpcA == 1
			//-------------------------------------
			// Executar a interface de atendimento.
			//-------------------------------------
			cUC_XDIPROP := Date()
			cUC_XHIPROP := Time()
			A110Regist(nAba,@oGride)
		Elseif nOpcA == 2 .AND. cMV_TSDISCA == 'S'
			//--------------------------------------------------------------------------------------
			// Solicitar o status da discagem caso não obtiver sucesso na chamada telefônica/e-mail.
			//--------------------------------------------------------------------------------------
			AAdd(aPar,{3,'Status da discagem',1,aSTADISC,110,'',.T.})
			If cU7_TIPO=='2'
				AAdd(aPar,{9,'INFORMAÇÃO: Parâmetros abaixo para manutenção.'      ,180,7,.T.})
				AAdd(aPar,{9,'MV_STADISC - Opções para status da discagem.'        ,180,7,.T.})
				AAdd(aPar,{9,'MV_STATVLD - Opções válidas para status da discagem.',180,7,.T.})
			Endif
			If ParamBox(aPar,'Status da discagem',@aRet,,,,,,,,.F.,.F.)
				A110GrvHist(cU4_LISTA,cU6_CONTATO,aRet)
			Else
				MsgAlert('Operação não foi concluída.',cCadastro)
			Endif
		Endif
	Endif
	oGride:oBrowse:SetFocus()
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110GrvHist  | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ gravar o histórico de tentativa de ligação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110GrvHist(cU6_LISTA,cU6_CONTATO,aRet)
	SU8->(RecLock("SU8",.T.))
	SU8->U8_FILIAL  := xFilial("SU8")
	SU8->U8_CRONUM  := cU6_LISTA
	SU8->U8_CONTATO := cU6_CONTATO
	SU8->U8_DATA    := MsDate()
	SU8->U8_HROCOR  := Time()
	SU8->U8_STATUS  := LTrim(Str(aRet[1]))
	SU8->(MsUnLock())
	MsgInfo('Operação de registrar a tentativa gravada com sucesso.',cCadastro)
Return

//-----------------------------------------------------------------------
// Rotina | A110regist   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/efetuar o atend. ativo conforme atividade da agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Regist(nAba,oGride,cCodCont)
	Local oDlg
	Local oPnl1
	Local oPnl2
	Local oEnch
	Local oScroll
	Local oScroll2
	Local oSplitter
	Local oFntBox
	Local oTLbx
	
	Local aPos 	:= {0,0,180,600}
	Local aCpoEnch	:= {}
	Local aAlterEnch := {}
	Local aCpoCfg := {}
	Local aField := {}
	Local aSay := {}
	Local aCpoLst := {}
	Local aDados := {}
	Local aSize := {}
	Local aButtons := {}
	
	Local nX := 0
	Local nOpc := 0
	Local nI := 0
	Local nP := 0
	Local nList := 0
	Local nLargPanel := 0
	
	Local cTitulo := ''
	Local cF3 := ''
	Local cValid := ''
	Local cPicture := ''
	Local cWhen := ''
	Local cDado := ''
	Local cMV_ENCHOLD := ''
	
	Local lMemoria := .F.
	Local lObrigat := .F.
	Local lPutMvEnchOld := .F.
	
	Local nU4_DESC := 0
	
	Local aCabec := {}
	Local aItens := {}
	Private oGetDa
		
	Private aRetEncer := {}
	Private nLin := 0
	Private nU4_RECNO := 0
	Private nU6_RECNO := 0
	Private cU6_CODOPER := ''
	Private cUC_INICIO := ''
	Private cUC_CODIGO := ''
	Private aUD_RECNO := {}

	//------------------------------------------------------
	// Verificar se o usuário está cadastrado como operador.
	//------------------------------------------------------
	cU6_CODOPER := SU7->(Posicione('SU7',4,xFilial('SU7')+__cUserID,'U7_CODUSU'))
	If Empty(cU6_CODOPER)
		MsgInfo('Usuário não está cadastrado como operador.',cCadastro)
		Return
	Endif
	
	INCLUI := .T.
	ALTERA := .F.
	
	oFntBox := TFont():New( "Courier New",,-11)
	
	If !SXB->(dbSeek('T1_110'))
		T1_110()
	Endif

	If !SXB->(dbSeek('SUR110'))
		SUR110()
	Endif
	
	If !SXB->(dbSeek('SU9110'))
		SU9110()
	Endif

	//---------------------------
	// Montar dados para o TList.
	//---------------------------
	If Valtype(cCodCont) == "U"
		nLin := oGride:nAt
	Else
		//Renato Ruy - 15/06/16
		//Se posiciona na linha que foi criada.
		nLin := AScan(oGride:aHeader,{|p| AllTrim(p[2])=='U4_LISTA'})
		nLin := AScan(oGride:aCols,{|p| AllTrim(p[nLin])==AllTrim(cCodCont)})
		//Informo a linha atual do registro gerado.
		oGride:nAt := nLin
		
		If nLin < 1
			MsgInfo("Não foi possível encontrar o atendimento na lista do analista selecionado.","Agenda Certisign")
			Return .F.
		Endif
	EndIf
	
	nU4_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
	nU5_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U5_RECNO'})
	nU6_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U6_RECNO'})
	
	nU4_RECNO := oGride:aCOLS[nLin,nU4_RECNO]
	nU5_RECNO := oGride:aCOLS[nLin,nU5_RECNO]
	nU6_RECNO := oGride:aCOLS[nLin,nU6_RECNO]
	
	SU4->(dbGoTo(nU4_RECNO))
	SU5->(dbGoTo(nU5_RECNO))
	SU6->(dbGoTo(nU6_RECNO))

	AAdd( aCpoLst ,{'U5_CODCONT' ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_CONTAT'  ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_DDD'     ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FONE'    ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_CELULAR' ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FCOM1'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FCOM2'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_EMAIL'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'GD_LEGENDA' ,''             ,''   } )
	AAdd( aCpoLst ,{'U4_DATA'    ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U4_HORA1'   ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U6_ENTIDA'  ,'Sigla Entid.' ,'SU6'} )
	AAdd( aCpoLst ,{'U6_DENTIDA' ,'Descr.sigla ' ,'SU6'} )
	AAdd( aCpoLst ,{'U4_DESC'    ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U4_LISTA'   ,''             ,'SU4'} )
	
	SX3->(dbSetOrder(2))
	For nI := 1 To Len(aCpoLst)
		If Empty(aCpoLst[nI,2])
			If SX3->(dbSeek(aCpoLst[nI,1]))
				cTitulo := SX3->X3_TITULO
			Else
				cTitulo := 'Legenda     '
			Endif
		Else
			cTitulo := aCpoLst[nI,2]
		Endif
		nP := AScan(oGride:aHeader,{|p| p[2]==aCpoLst[nI,1]})
		If nP > 0
			cDado := oGride:aCOLS[nLin,nP]
		Else
			cDado := &(aCpoLst[nI,3]+'->'+aCpoLst[nI,1])
		Endif
		If Valtype(cDado)=='N'
			cDado := LTrim(TransForm(cDado,'@E 999,999,999.99'))
		Elseif ValType(cDado)=='D'
			cDado := Dtoc(cDado)
		Endif
		AAdd(aDados,cTitulo+': '+cDado)
	Next nI
	
	//Estrutura do vetor
	//[1] - Campo
	//[2] - Título
	//[3] - F3
	//[4] - Valid
	//[5] - Obrigatório => .T. sim, .F. considerar o que está no SX3.
	//[6] - Picture
	//[7] - When
	AAdd(aCpoCfg,{'UC_TIPO'   ,'Tp.Comunic.'      ,''      ,'Vazio().Or.(ExistCpo("SUL",M->UC_TIPO).And.U_A110Gat01())',.T.,'',''})
	AAdd(aCpoCfg,{'UC_DESCTIP','Descr.Tp.Comun.'  ,'','',.F.,'',''})
	/*
	//Renato Ruy - 29/06/2016
	//O usuário passará a informar vários produtos na getdados
	If FindFunction('U_CSFA200')
		AAdd(aCpoCfg,{'UD_PRODUTO','Produto'  ,'PRT200','(ExistCpo("SB1",M->UD_PRODUTO).And.U_A110Gat01()).Or.Vazio()',.F.,'',''})
	Else
		AAdd(aCpoCfg,{'UD_PRODUTO','Produto'  ,'PRT','(ExistCpo("SB1",M->UD_PRODUTO).And.U_A110Gat01()).Or.Vazio()',.F.,'',''})
	Endif
	AAdd(aCpoCfg,{'UD_DESCPRO','Descr.produto'  ,'','',.F.,'',''})
	AAdd(aCpoCfg,{'UD_QUANT'  ,'Quantidade'  ,'','Positivo().And.U_A110Gat01()',.T.,'@E 999,999,999.99','.NOT.Empty(M->UD_PRODUTO)'})
	AAdd(aCpoCfg,{'UD_VUNIT'  ,'Vl. Unitário','','Positivo().And.U_A110Gat01()',.T.,'@E 999,999,999.99','.NOT.Empty(M->UD_PRODUTO)'})
	AAdd(aCpoCfg,{'UD_TOTAL'  ,'Valor total'      ,'','',.F.,'@E 999,999,999.99',''})
	*/
	AAdd(aCpoCfg,{'UD_ASSUNTO' ,'Cód.do assunto'    ,'T1_110' ,'Vazio().Or.(ExistCpo("SX5","T1"+M->UD_ASSUNTO).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCASS' ,'Descr.do assunto'  ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UD_OCORREN' ,'Cód.da ocorrên.'   ,'SU9110' ,'Vazio().Or.(ExistCpo("SU9",M->UD_ASSUNTO+M->UD_OCORREN).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCOCO' ,'Descr.da ocorrên.' ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UD_SOLUCAO' ,'Código da ação'    ,'SUR110' ,'Vazio().Or.(ExistCpo("SUQ",M->UD_SOLUCAO).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCSOL' ,'Descr.da ação'     ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UD_STATUS'  ,'Status do atend.'  ,''       ,'.T.' ,.T. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_PENDENT' ,'Data do retorno'   ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_HRPEND'  ,'Hora do retorno'   ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_XLEMBR'  ,'Lembrete'          ,''       ,'.T.' ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_XEXPECT' ,'Valor Expectativa' ,''       ,''    ,.T. ,''   ,''    })
	AAdd(aCpoCfg,{'U4_XPRIOR'  ,'Prioridade'        ,''       ,''    ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_XCARGO'  ,'Cargo'             ,''       ,'.T.' ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_XCONCOR' ,'Inf. Concorr.'     ,''       ,'.T.' ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UC_XPROXAC' ,'Proxima Acao'      ,''       ,'.T.' ,.F. ,''   ,''    })
	AAdd(aCpoCfg,{'UD_OBS'     ,'Título do assunto' ,''       ,''    ,.T. ,"@!" ,'.F.' })
	AAdd(aCpoCfg,{'UD_OBSEXEC' ,'Registrar atend.'  ,''       ,''    ,.T. ,''   ,''    })
	
	// cAlias - Prefixo da tabela.
	// lInicialização de operação -> .T. Inclusão.
	// lDicionário - Características baseadas no SX3.
	// lInicialização do dicionário será executada?
	RegToMemory( "SU4", .T., .T., .F. )
	RegToMemory( "SUC", .T., .T., .F. )
	RegToMemory( "SUD", .T., .T., .F. )
	
	M->U4_XPRIOR := SU4->U4_XPRIOR
	
	SX3->(dbSetOrder(2))
	For nX := 1 To Len(aCpoCfg)
		If SX3->(dbSeek(aCpoCfg[nX,1]))
			cTitulo  := Iif(Empty(aCpoCfg[nX,2]),SX3->X3_TITULO,aCpoCfg[nX,2])
			cF3      := Iif(Empty(aCpoCfg[nX,3]),SX3->X3_F3    ,aCpoCfg[nX,3])
			cValid   := Iif(Empty(aCpoCfg[nX,4]),SX3->X3_VALID ,aCpoCfg[nX,4])
			lObrigat := Iif(aCpoCfg[nX,5],aCpoCfg[nX,5],X3Obrigat(SX3->X3_CAMPO))
			cPicture := Iif(Empty(aCpoCfg[nX,6]),SX3->X3_PICTURE,aCpoCfg[nX,6])
			cWhen    := Iif(Empty(aCpoCfg[nX,7]),SX3->X3_WHEN,aCpoCfg[nX,7])
			
	   	AAdd( aField, {	cTitulo,;
							SX3->X3_CAMPO,;
							SX3->X3_TIPO,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							cPicture,;
							&("{||" + AllTrim(cValid)+ "}"),;
							lObrigat,;
							SX3->X3_NIVEL,;
							SX3->X3_RELACAO,;
							cF3,;
							&("{||" + RTrim(cWhen) + "}"),;
							SX3->X3_VISUAL=="V",;
							.F.,; 
							SX3->X3_CBOX,;
							VAL(SX3->X3_FOLDER),;
							.F.,;
							""} )
		Endif
	Next nX
		
	nU4_DESC := AScan(oGride:aHeader,{|p| p[2]=='U4_DESC'})
	M->UD_OBS := oGride:aCOLS[oGride:nAt,nU4_DESC]
	
	//------------------------------------------------------------------------------------------------------------
	// Parâmetro MV_ENCHOLD controla a visualização da Enchoice ou MsMGet no padrão das versões anteriores ao P11.
	// Modificar o conteúdo para o padrão antigo e logo que executar a classe reestabelecer o conteúdo original.
	//------------------------------------------------------------------------------------------------------------
	cMV_ENCHOLD := GetMv('MV_ENCHOLD',,'1')
	If cMV_ENCHOLD<>'1'
		cMV_ENCHOLD := '1'
		lPutMvEnchOld := .T.
		PutMv('MV_ENCHOLD','1')
	Endif	
	If cMV_ENCHOLD=='1'
		nLargPanel := 170
		aSize := {0,0,0,0,1000,400,0}
	Else
		nLargPanel := 40
		aSize := MsAdvSize( .T. )
	Endif
	
	DEFINE MSDIALOG oDlg TITLE "Registro do atendimento Ativo" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL 
		oDlg:lMaximized := (GetMv('MV_110DIM')=='1')
		
		oSplitter := TSplitter():New(1,1,oDlg,260,184,2)
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl1:= TPanel():New(2,2,,oSplitter,,,,,RGB(67,70,87),nLargPanel,60)
		oPnl1:Align := CONTROL_ALIGN_LEFT
		
		oPnl2:= TPanel():New(2,2,,oSplitter,,,,,RGB(67,70,87),60,26)
		oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
	
	   oScroll := TScrollBox():New(oPnl1,1,1,100,100,.T.,.F.,.T.)
	   oScroll:Align := CONTROL_ALIGN_ALLCLIENT

		oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oScroll,,,,.T.,,,oFntBox)
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx:SetArray(aDados)
		
		oScroll2 := TScrollBox():New(oPnl2,0,0,120,332,.T.,.F.,.T.)

		oEnch := MsMGet():New(	"SUC"				,;
									SUC->(RecNo())	,;
									3					,;
									/*aCRA*/			,;
									/*cLetras*/		,;
									/*cTexto*/			,;
									aCpoCfg			,;
									aPos				,;
									/*aAlterEnch*/	,;
									/*nModelo*/		,;
									/*nColMens*/		,;
									/*cMensagem*/		,;
									/*cTudoOk*/		,;
 									oScroll2			,;
									/*lF3*/			,;
									lMemoria			,;
									/*lColumn*/		,;
		        					/*caTela*/			,;
		        					/*lNoFolder*/		,;
		        					/*lProperty*/		,;
		        					aField				,;
		        					/*aFolder*/		,;
		        					/*lCreate*/		,;          
		        					/*lNoMDIStretch*/	,;
		        					/*cTela*/ )
		        					   
		//oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT 
		
		//Renato Ruy - 29/06/2016
		//Viabilizar o vinculo de múltiplos produtos a um atendimento.
		AAdd(aCabec,{'Produto'		 ,'UD_PRODUTO' ,"@!"                ,15 ,0 ,'(ExistCpo("SB1",M->UD_PRODUTO).And.U_A110Gat01("UD_PRODUTO")).Or.Vazio()'	,"û","C","",,,,,,, } )
		AAdd(aCabec,{'Descr.produto' ,'UD_DESCPRO' ,"@!"                ,40 ,0 ,"AllWaysTrue()"												 				       ,"û","C","",,,,,,, } )
		AAdd(aCabec,{'Quantidade'	 ,'UD_QUANT'	 ,"@E 999,999,999.99" ,15 ,2 ,'Positivo().And.U_A110Gat01("UD_QUANT")'										,"û","N","",,,,,,, } )
		AAdd(aCabec,{'Vl. Unitário'	 ,'UD_VUNIT'	 ,"@E 999,999,999.99" ,15 ,2 ,'Positivo().And.U_A110Gat01("UD_VUNIT")'								 		,"û","N","",,,,,,, } )
		AAdd(aCabec,{'Valor total'	 ,'UD_TOTAL'	 ,"@E 999,999,999.99" ,15 ,2 ,"AllWaysTrue()"														 		       ,"û","N","",,,,,,, } )

		aadd(aItens,Array(Len(aCabec)+1))
		For i := 1 to Len(aCabec)
			aItens[Len(aItens),i] := Criavar(aCabec[i,2])
		Next
		aItens[1,len(aCabec)+1]:=.f.
		
		oGetDa := MSNewGetDados():New(120,0,188,332,GD_INSERT + GD_UPDATE + GD_DELETE,.T.,.T.,"",nil,,,,,.T.,oPnl2,aCabec,aItens,{||.T.})
		
		//-----------------------------------
		// Reestabelecer o conteúdo original.
		//-----------------------------------
		PutMv('MV_ENCHOLD','2')
		
		//-------------------------------------------------------------------------------------------------
		// Esta variável está sendo atribuída aqui para calcular o tempo do usuário e não do processamento.
		//-------------------------------------------------------------------------------------------------
		cUC_INICIO := Time()
		
		Aadd( aButtons, {"CLIENTE", {|| U_CSFA112(@(&("oGride" + cValToChar(nAba))))}, "Gera Cliente...", "Gera Cliente" , {|| .T.}} )
		
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| Iif(A110TudOk(aCpoCfg,oGetDa),(nOpc:=1,oDlg:End()),NIL)}, {|| oDlg:End() },, @aButtons )
	
	If nOpc == 1
		nLin := oGride:nAt
		
		nU4_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
		nU6_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U6_RECNO'})
		
		nU4_RECNO := oGride:aCOLS[nLin,nU4_RECNO]
		nU6_RECNO := oGride:aCOLS[nLin,nU6_RECNO]
		
		BEGIN TRANSACTION
			If A110BaixaLst(nAba,oGride)
				If A110GrvAtend(nAba,oGride)
					If A110GerList(nAba)
						oGride:GoTo(nLin)
						If A110AtuGetD(nAba,@oGride)
							MsgInfo('Operação efetuada com sucesso.',cCadastro)
						Endif
					Endif
				Endif
			Endif
		END TRANSACTION
		DbUnLockAll()
		
		
		//+------------------------------------------------------------------------+
		//| Nome: David Santos                                                     | 
		//| Data: 17/11/2016                                                       |
		//| Descricao: Chamada do proximo processo atraves do campo: Proxima Acao. |
		//+------------------------------------------------------------------------+
		Do Case
			Case M->UC_XPROXAC == "1"	//-- 1 = Proposta.
				//+---------------------------------------------------------------------------------------------+
				//| Na inclusao manual deixando o status como pendente, o sistema ainda nao alimenta as tabelas |
				//| necessarias para gerar a proposta, sendo assim, se estiver como pendente ele nao gera.      |
				//+---------------------------------------------------------------------------------------------+ 
				If !IsInCallStack("csfa111g") .Or. M->UD_STATUS <> "1" 
					U_A322IPro(@oGride)
				Else
					MsgInfo("A geração de proposta automatica através da inclusao manual não pode ser realizada, favor gerar a proposta após o atendimento!", "Inclusão manual de agenda")
				EndIf
			Case M->UC_XPROXAC == "2"	//-- 2 = Faturamento.
				A110IncTlv(@oGride)
			Case M->UC_XPROXAC == "3"	//-- 3 = Oportunidade.
				A110oportu(@oGride)
		EndCase
						
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110BaixaLst | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para baixar a agenda do operador.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110BaixaLst(nAba,oGride)
	Local lRet       := .T.
	
	Local nRegistro  := 0
	Local nEncerrado := 0
	
	Local cU6_LISTA  := ''
	
	//-------------------------------------------------------
	// Mudar o status no item da lista de contato em questão.
	//-------------------------------------------------------
	SU6->(dbGoTo(nU6_RECNO))
	If SU6->(RecNo()) == nU6_RECNO
		cU6_LISTA := SU6->U6_LISTA
		
		SU6->(RecLock('SU6',.F.))
			SU6->U6_STATUS  := '3'
			SU6->U6_CODOPER := cU6_CODOPER
			SU6->U6_DTATEND := MsDate()
			SU6->U6_HRATEND := Time()
		SU6->(MsUnLock())
		
		SU6->(dbSetOrder(1))
		SU6->(dbSeek(xFilial('SU6')+cU6_LISTA))
		While ! SU6->(EOF()) .And. SU6->(U6_FILIAL+U6_LISTA)==xFilial("SU6")+cU6_LISTA
			If SU6->U6_STATUS == '3'
				nEncerrado++
			Endif
			nRegistro++
			SU6->(dbSkip())
		End
		
		If nRegistro == nEncerrado
			SU4->(dbGoTo(nU4_RECNO))
			If SU4->(RecNo()) == nU4_RECNO
				SU4->(RecLock('SU4',.F.))
					SU4->U4_STATUS := '2'
				SU4->(MsUnLock())
			Else
				lRet := .F.
				MsgAlert('Não consegui localizar o cabeçalho da agenda do operador.',cCadastro)
				Disarmtransaction()
				BREAK
			Endif
		Endif
	Else
		lRet := .F.
		MsgAlert('Não consegui baixar a agenda do operador.',cCadastro)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110GrvAtend | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar o atendimento, seja primeiro ou retorno.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110GrvAtend( nAba, oGride )
	Local cUC_OBS     := ''
	Local cUD_ITEM    := ''		
	Local cSQL        := ''
	Local cTRB        := ''
	Local cTab        := ''
	Local aArea       := {}
	Local nU6_ATENDIM := 0
	Local nU4_LISTA   := ""
	Local nMV_XGEROPO := GetMv("MV_XGEROPO")
	Local cQosmarosauery      := ""
	Local cTmp        := GetNextAlias()
	Local cHora       := ""
	Local cMvSubHor   := SuperGetMv("MV_SUBHOR",.F., "00:05:00")
	
	aArea := GetArea()
	
	//------------------------------------------------------------
	// Posicionar no cabeçalho da agenda que está sendo executada.
	//------------------------------------------------------------
	dbSelectArea( 'SU4' )
	If SU4->(RecNo())<>nU4_RECNO
		SU4->(dbGoTo(nU4_RECNO))	
	Endif
	
	//-------------------------------------------------------
	// Posicionar no item da agenda que está sendo executada.
	//-------------------------------------------------------
	dbSelectArea( 'SU6' )
	If SU6->(RecNo())<>nU6_RECNO
		SU6->(dbGoTo(nU6_RECNO))	
	Endif	
	
	//-------------------------------------------------------------------------------------------
	// Quando o campo U4_CODLIG está vazio não é retorno de ligação, ou seja, é atendimento novo.
	//-------------------------------------------------------------------------------------------
	If Empty( SU4->U4_CODLIG )
	
		cTab := SU6->U6_ENTIDA
		(cTab)->( dbSetOrder( 1 ) )
		(cTab)->( dbSeek( xFilial( cTab ) + RTrim( SU6->U6_CODENT ) ) )
	
		If SU6->U6_ENTIDA == 'SZT'			
			cUC_OBS := 	"Common name: "     + RTrim( SZT->ZT_COMMON  ) + CRLF + ;
							"Produto: "         + RTrim( SZT->ZT_PRODUTO ) + CRLF + ;
							"Contato técnico: " + RTrim( SZT->ZT_CONTTEC ) + CRLF + ;
							"Data inclusão: "   + Dtoc(  SZT->ZT_DT_INC  ) + CRLF + ;
							"Data validade: "   + Dtoc(  SZT->ZT_DT_VLD  )
	   Elseif SU6->U6_ENTIDA == 'SZX'
			cUC_OBS := 	"ICP-Brasil: "      + RTrim( SZX->ZX_NMCLIEN  ) + CRLF + ;
							"Produto: "         + RTrim( SZX->ZX_CDPRODU  ) + CRLF + ;
							"Contato técnico: " + RTrim( SZX->ZX_DSEMAIL  ) + CRLF + ;
							"Data inclusão: "   + Dtoc(  SZX->ZX_DTEMISS  ) + CRLF + ;
							"Data validade: "   + Dtoc(  SZX->ZX_DTEXPIR  )
	   Endif
	         
		//-----------------------------------------------------------------------------------------------------
		// MSMM( cChave, nTam, nLin, cString, nOpc, nTamSize, lWrap, cAlias, cCpoChave, cRealAlias, lSoInclui )
		//-----------------------------------------------------------------------------------------------------
		// <cChave>     - chave de código para a busca.
		// <nTam>       - o valor padrão é o tamanho do campo do SYP.
		// <nLin>       - linha do campo memo a ser retornada.
		// <cString>    - texto do campo memo.
		// <nOpc>       - opção a ser executada pela função.
		// <nTamSize>   - quantidade de caracteres.
		// <lWrap>      - habilita a quebra de linha de acordo com a palavra.
		// <cAlias>     - prefixo da tabela.
		// <cCpoChave>  - campos de chave.
		// <cRealAlias> - prefixo real.
		// <lSoInclui>  - somente realiza a inclusão.
		//-----------------------------------------------------------------------------------------------------
		cUD_ITEM := '01'		
		cUC_CODIGO := TkNumero('SUC','UC_CODIGO')
		
		dbSelectArea('SUC')
		SUC->(RecLock('SUC',.T.))
			SUC->UC_FILIAL  := xFilial('SUC')
			SUC->UC_CODIGO  := cUC_CODIGO
			SUC->UC_DATA    := MsDate()
			SUC->UC_XEXPECT := M->UC_XEXPECT
			SUC->UC_CODCONT := SU6->U6_CONTATO
			SUC->UC_ENTIDAD := SU6->U6_ENTIDA
			SUC->UC_CHAVE   := SU6->U6_CODENT
			SUC->UC_OPERADO := SU4->U4_OPERAD
			SUC->UC_OPERACA := '2' //1=Receptivo;2=Ativo.
			SUC->UC_STATUS  := Iif(M->UD_STATUS=='1','2','3') // 1 no UC_STATUS é planejada, 2 é pendente e 3 é encerrada, isso foi compatibilizado com UD_STATUS.
			SUC->UC_INICIO  := cUC_INICIO
			SUC->UC_FIM     := TIME()
			SUC->UC_DIASDAT := (CTOD("01/01/2045","dd/mm/yyyy") - MsDate())
			SUC->UC_HORADAT := 86400 - ( (VAL(Substr(cUC_INICIO,1,2))*3600) + ( VAL(Substr(cUC_INICIO,4,2))*60) + VAL(Substr(cUC_INICIO,7,2)))
			SUC->UC_TIPO    := M->UC_TIPO
			SUC->UC_XCARGO  := M->UC_XCARGO
			SUC->UC_XCONCOR := M->UC_XCONCOR
			MSMM(,TamSx3("UC_OBS")[1],,cUC_OBS,1,,,"SUC","UC_CODOBS")
			If M->UD_STATUS == '1' //Pendente.
				SUC->UC_PENDENT := M->UC_PENDENT
				SUC->UC_HRPEND  := M->UC_HRPEND
			Endif
			If M->UD_STATUS == '2' //Encerrado.
				SUC->UC_DTENCER := MsDate()
				SUC->UC_CODENCE := aRetEncer[1]
				MSMM(,TamSx3("UC_OBSMOT")[1],,aRetEncer[2],1,,,"SUC","UC_CODMOT")
			Endif
			SUC->UC_XDIPROP := cUC_XDIPROP
			SUC->UC_XHIPROP := cUC_XHIPROP
		SUC->(MsUnLock())		
	Else
		//-----------------------------------------------------------------------------------------------
		// Quando o campo U4_CODLIG não está vazio é retorno de ligação, ou seja, não é atendimento novo.
		//-----------------------------------------------------------------------------------------------
		cSQL := "SELECT ISNULL(MAX(UD_ITEM),'') AS UD_ITEM " + CRLF
		cSQL += "FROM "+RetSqlName("SUD") + " " + CRLF 
		cSQL += "WHERE UD_FILIAL = " + ValToSql(xFilial("SUD")) + " " + CRLF
		cSQL += "      AND UD_CODIGO = " + ValToSql(SU4->U4_CODLIG) + " "
		cSQL += "      AND D_E_L_E_T_ = ' ' "
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		PLSQuery( cSQL, cTRB )
		cUD_ITEM := (cTRB)->UD_ITEM
		(cTRB)->(dbCloseArea())	
		
		cUC_CODIGO := SU4->U4_CODLIG
		cUD_ITEM := cUD_ITEM
		
		//---------------------------------------------
		//Se for status Pendente, atribuir a nova data.
		//---------------------------------------------
		dbSelectArea('SUC')
		If M->UD_STATUS == '1' 
			SUC->( RecLock( 'SUC', .F. ) )
			SUC->UC_PENDENT := M->UC_PENDENT
			SUC->UC_HRPEND  := M->UC_HRPEND
			SUC->UC_XEXPECT := M->UC_XEXPECT
			SUC->( MsUnLock() )
		Endif
		//--------------------------------------------------------------
		//Se for status Encerrado, finalizar o cabeçalho do atendimento.
		//--------------------------------------------------------------
		If M->UD_STATUS == '2' 
			SUC->(dbSetOrder(1))
			If SUC->(dbSeek(xFilial('SUC')+cUC_CODIGO))
				SUC->(RecLock('SUC',.F.))
				SUC->UC_STATUS  := Iif(M->UD_STATUS=='1','2','3') // 1 no UC_STATUS é planejada, 2 é pendente e 3 é encerrada, isso foi compatibilizado com UD_STATUS.
				SUC->UC_DTENCER := MsDate()
				SUC->UC_CODENCE := aRetEncer[1]
				SUC->UC_XEXPECT := M->UC_XEXPECT
				MSMM(,TamSx3("UC_OBSMOT")[1],,aRetEncer[2],1,,,"SUC","UC_CODMOT")
				SUC->(MsUnLock())
			Endif
		Endif
	Endif
	//+--------------------------------------+
	//| David.Santos - 08/06/2017            |
	//| Controle de lembrete de agendamento. |
	//+--------------------------------------+
	If ChkFile("ZZY")
		If M->UC_XLEMBR == "S"
			
			//-- Montagem da Query.
			cQuery := " SELECT a3.A3_CODUSR "
			cQuery += " FROM   SU7010 u7 "
			cQuery += "        INNER JOIN SA3010 a3 "
			cQuery += "                ON u7.U7_CODVEN = a3.A3_COD  AND A3.D_E_L_E_T_=' ' AND A3_MSBLQL='2' "
			cQuery += " WHERE  U7_COD = '" + SU4->U4_OPERAD + "' AND U7.D_E_L_E_T_=' ' "
			
			//-- Verifica se a tabela esta aberta.
			If Select(cTmp) > 0
				cTmp->(DbCloseArea())				
			EndIf
			
			//-- Execucao da query.
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
			
			If !Empty((cTmp)->A3_CODUSR)
				
				cHora := CSFA110HOR(M->UC_HRPEND, cMvSubHor)
				
				//-- Alimentação da tabela ZZY para alerta de agendamento.
				ZZY->(RecLock('ZZY',.T.))
				
					ZZY->ZZY_FILIAL := xFilial("ZZY")							//-- Filial.
					ZZY->ZZY_STATUS := "P" 										//-- Status | P=Pendente; E=Enviado; F=Falha de envio.  
					ZZY->ZZY_DATAG  := M->UC_PENDENT							//-- Data do agendamento.
					ZZY->ZZY_HORAG  := cHora									//-- Hora do agendamento.
					ZZY->ZZY_AGENDA := cUC_CODIGO								//-- Agenda.
					ZZY->ZZY_OPERAD := SU4->U4_OPERAD							//-- Código do operador.
					ZZY->ZZY_MAILOP := UsrRetMail((cTmp)->A3_CODUSR)			//-- E-mail do operador.
					ZZY->ZZY_CONTAT := AllTrim(SU5->U5_CONTAT)  				//-- Nome do contato.
					
					//-- Compara entidade para alimentar o campo ZZY_EMPRES.
					If SU6->U6_ENTIDA == "SZT"		//-- SSL RENOV. COMMON NAME
						ZZY->ZZY_EMPRES :=  SZT->ZT_EMPRESA
					ElseIf SU6->U6_ENTIDA == "SZX"	//-- ICP-BRASIL
						ZZY->ZZY_EMPRES :=  SZX->ZX_NMCLIEN
					ElseIf SU6->U6_ENTIDA == "PAB"	//-- LISTAS DE CONTATOS
						ZZY->ZZY_EMPRES :=  PAB->PAB_EMPRES
					ElseIf SU6->U6_ENTIDA == "SA1"	//-- CLIENTES
						ZZY->ZZY_EMPRES :=  SA1->A1_NOME
					ElseIf SU6->U6_ENTIDA == "SUS"	//-- PROSPECTS
						ZZY->ZZY_EMPRES :=  SUS->US_NOME
					ElseIf SU6->U6_ENTIDA == "ACH"	//-- SUSPECTS
						ZZY->ZZY_EMPRES :=  ACH->ACH_RAZAO
					EndIf
						
					ZZY->ZZY_LOG := "["+DToC(Date()) +" "+ Time() +"] " + "Lembrete incluido com sucesso." + Pula_Linha	//-- Log.
				
				ZZY->(MsUnLock())
			
			EndIf
		EndIf
	EndIf    
	SU4->(RecLock('SU4',.F.))
		SU4->U4_XPRIOR := M->U4_XPRIOR
	SU4->(MsUnlock())
	
	dbSelectArea('SUD')
	For nT := 1 to  Len(oGetDa:aCols)
		If !oGetDa:aCols[nT,Len(oGetDa:aHeader)+1]
			SUD->(RecLock('SUD',.T.))
				SUD->UD_FILIAL  := xFilial('SUD')
				SUD->UD_CODIGO  := cUC_CODIGO
				SUD->UD_ITEM    := PadL(AllTrim(Str(nT+VAL(cUD_ITEM))),2,"0")
				SUD->UD_PRODUTO := oGetDa:aCols[nT, AScan(oGetDa:aHeader, {|p| p[2]=='UD_PRODUTO'})]
				SUD->UD_QUANT   := oGetDa:aCols[nT, AScan(oGetDa:aHeader, {|p| p[2]=='UD_QUANT'})]
				SUD->UD_VUNIT   := oGetDa:aCols[nT, AScan(oGetDa:aHeader, {|p| p[2]=='UD_VUNIT'})]
				SUD->UD_TOTAL   := oGetDa:aCols[nT, AScan(oGetDa:aHeader, {|p| p[2]=='UD_TOTAL'})]
				SUD->UD_ASSUNTO := M->UD_ASSUNTO
				SUD->UD_OCORREN := M->UD_OCORREN
				SUD->UD_SOLUCAO := M->UD_SOLUCAO
				SUD->UD_DATA    := MsDate()
				SUD->UD_STATUS  := '2' //Sempre será encerrado, pois poderá ser reagendado caso o SUC for pendente.
				SUD->UD_OBS     := M->UD_OBS	
				MSMM(,TamSx3("UD_OBSEXEC")[1],,M->UD_OBSEXEC,1,,,"SUD","UD_CODEXEC")
				If M->UD_STATUS == '2' //Encerrado.
					SUD->UD_DTEXEC  := MsDate()	
				Endif
			SUD->(MsUnLock())
			//--------------------------------------------------------------------------
			// Armazenar o posicionamento do item do atendimento para futuras consultas.
			//--------------------------------------------------------------------------
			Aadd(aUD_RECNO,SUD->(RecNo()))
		EndIf
	Next
	
	//--------------------------------------------------------------------------------------------------------------------
	// Gravar o código do atendimento e item na agenda que o originou para consultas futuras. Isto é específico CERTISIGN.
	//--------------------------------------------------------------------------------------------------------------------
	If SU6->(FieldPos('U6_ATENDIM'))>0
		SU6->(RecLock('SU6',.F.))
		SU6->U6_ATENDIM := cUC_CODIGO+cUD_ITEM
		SU6->(MsUnLock())
		// Atualizar a MsNewGetDados com o número do atendimento.
		nU6_ATENDIM := AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_ATENDIM' } )
		oGride:aCOLS[ oGride:nAt, nU6_ATENDIM ] := cUC_CODIGO+cUD_ITEM
		oGride:oBrowse:Refresh()
		oGride:oBrowse:SetFocus()
		// Atualizar o vetor original, seja da pasta 1 ou pasta 3.
		If nAba == 1
			aCOLS1[ oGride:nAt, nU6_ATENDIM ] := cUC_CODIGO+cUD_ITEM
		Elseif nAba == 3
			aCOLS3[ oGride:nAt, nU6_ATENDIM ] := cUC_CODIGO+cUD_ITEM
		Endif
	Endif
	//Renato Ruy - 19/07/16
	//Gera a oportunidade de forma automatica atraves do valor de expectativa.
	If M->UC_XEXPECT >= nMV_XGEROPO
		MsgInfo("Para este atendimento deve ser gerado uma oportunidade"+ CRLF +"Motivo: valor de expectativa ultrapassou o valor :"+Transform(nMV_XGEROPO,"@E 999,999,999.99"),"Agenda Certisign")
		//Armazena as informacoes para gerar oportunidade.
		nU4_LISTA   := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_LISTA'	  } ) ]
		nU6_ATENDIM := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U6_ATENDIM'	  } ) ]
		//chama rotina de geracao de oportunidade
		U_CSFA220( 'CSFA110', nU6_ATENDIM, nU4_LISTA )
	EndIf

	RestArea( aArea )
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A110GerList  | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar nova lista de contato caso haja retorno.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110GerList(nAba)
	Local cU4_LISTA     := ''
	Local cU4_DESC      := ''
	Local dU4_DTEXPIR   := Ctod(Space(8))
	Local cU6_CODIGO    := ''
	Local cU4_OPERAD    := ''
	Local cU6_CONTATO   := ''
	Local cU6_ENTIDA    := ''
	Local cU6_CODENT    := ''
	Local cU4_XPRIOR    := ''
	Local coCOLS        := ''	//-- Origem
	Local coHeader      := ''	//-- Origem
	Local noPasta       := 0		//-- Origem
	Local cdCOLS        := ''	//-- Destino
	Local cdHeader      := ''	//-- Destino
	Local ndPasta       := 0		//-- Destino
	Local cPref         := ''
	Local cCampo        := ''
	Local cGride        := ''
	Local cBlock        := ''
	Local cGD_LEGENDA   := ''
	Local cLegenda      := ''
	Local cGlobal       := ''
	
	Local nStack        := 0
	Local nLin          := 0
	Local nCol          := 0
	Local nI            := 0
	Local nAt           := 0
	Local nP_GD_GLOBAL  := 0
	Local nP_GD_ITEM    := 0
	Local nP_GD_LEGENDA := 0
	Local nP_U4_CODLIG  := 0
	Local nP_U4_DESC    := 0
	Local nP_U5_CONTAT  := 0
	Local nP_U6_DESCENT := 0
	Local nP_U6_DENTIDA := 0
	Local nP_U4_RECNO   := 0
	Local nP_U5_RECNO   := 0
	Local nP_U6_RECNO   := 0
	Local nP_U6_ENTIDA  := 0
	
	//--------------------------------------------------------------------------------
	// Se pendente, gerar nova lista de contato, sendo assim o retorno do atendimento.
	//--------------------------------------------------------------------------------
	If M->UD_STATUS == '1' //Pendente.
	
		nStack := GetSX8Len()
		
		If SU4->(RecNo())<>nU4_RECNO
			SU4->(dbGoTo(nU4_RECNO))	
		Endif
		
		If SU6->(RecNo())<>nU6_RECNO
			SU6->(dbGoTo(nU6_RECNO))	
		Endif
		
		SU5->(dbSetOrder(1))
		SU5->(dbSeek(xFilial('SU5')+SU6->U6_CONTATO))
	
		cU4_LISTA  := GetSXENum("SU4","U4_LISTA")
		While GetSX8Len() > nStack 
			ConfirmSX8()
		End
		
		If 'Atend.' $ RTrim(SU4->U4_DESC)
			cU4_DESC := RTrim(SU4->U4_DESC)
		Else
			cU4_DESC  := 'Atend.' + cUC_CODIGO + ' - ' + RTrim(SU4->U4_DESC)
		Endif
		
		cU4_OPERAD  := SU4->U4_OPERAD
		dU4_DTEXPIR := SU4->U4_DTEXPIR
		cU4_XPRIOR  := SU4->U4_XPRIOR
		
		cU6_CONTATO := SU6->U6_CONTATO
		cU6_ENTIDA  := SU6->U6_ENTIDA
		cU6_CODENT  := SU6->U6_CODENT

		SU4->( RecLock( "SU4", .T. ) )
		SU4->U4_FILIAL  := xFilial("SU4")
		SU4->U4_TIPO    := "1" //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
		SU4->U4_STATUS  := "1" //1=Ativa;2=Encerrada;3=Em Andamento
		SU4->U4_LISTA   := cU4_LISTA
		SU4->U4_DESC    := cU4_DESC
		SU4->U4_DATA    := M->UC_PENDENT
		SU4->U4_DTEXPIR := dU4_DTEXPIR
		SU4->U4_HORA1   := M->UC_HRPEND
		SU4->U4_FORMA   := "6" //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
		SU4->U4_TELE    := "1" //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
		SU4->U4_OPERAD  := cU4_OPERAD
		SU4->U4_TIPOTEL := "4" //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
		SU4->U4_NIVEL   := "1" //1=Sim;2=Nao.
		SU4->U4_CODLIG  := cUC_CODIGO
		SU4->U4_XPRIOR  := M->U4_XPRIOR
		If SU4->( FieldPos("U4_XDTVENC") ) > 0
			SU4->U4_XDTVENC := M->UC_PENDENT
		Endif
		If SU4->( FieldPos("U4_XGRUPO") ) > 0
			SU4->U4_XGRUPO  := SU7->(Posicione('SU7',1,xFilial('SU7')+cU4_OPERAD,'U7_POSTO'))
		Endif
		SU4->( MsUnLock() )

		cU6_CODIGO := GetSXENum("SU6","U6_CODIGO")
		While GetSX8Len() > nStack 
			ConfirmSX8()
		End
		ConfirmSX8()
		
		SU6->( RecLock( "SU6", .T. ) )
		SU6->U6_FILIAL  := xFilial("SU6")
		SU6->U6_LISTA   := cU4_LISTA
		SU6->U6_CODIGO  := cU6_CODIGO
		SU6->U6_CONTATO := cU6_CONTATO
		SU6->U6_ENTIDA  := cU6_ENTIDA
		SU6->U6_CODENT  := cU6_CODENT
		SU6->U6_ORIGEM  := "1" //1=Lista;2=Manual;3=Atendimento.
		SU6->U6_DATA    := M->UC_PENDENT
		SU6->U6_HRINI   := M->UC_HRPEND
		SU6->U6_HRFIM   := M->UC_HRPEND
		SU6->U6_STATUS  := "1" //1=Nao Enviado;2=Em uso;3=Enviado.
		SU6->U6_CODLIG  := cUC_CODIGO
		SU6->U6_DTBASE  := MsDate()
		SU6->( MsUnLock() )
		
		//-------------------------------------------------------------------------------------------------
		// Verificar se está posicionado o registro de atendimento e gravar a lista de contato que o gerou.
		//-------------------------------------------------------------------------------------------------
		If Len(aUD_RECNO) > 0
			For nQ := 1 to Len(aUD_RECNO)
				SUD->(dbGoTo(aUD_RECNO[nQ]))
				SUD->(RecLock('SUD',.F.))
				SUD->UD_LSTCONT := cU4_LISTA + cU6_CODIGO
				SUD->(MsUnLock())
			Next
		Endif
		
		//-----------------------------------------------------------------------------------------------
		// Em qual aCOLS deverá ser atribuído o novo registro? Aba 1 igual a hoje e aba 3 maior que hoje.
		//-----------------------------------------------------------------------------------------------
		// qual é a pasta atual? nAba
		// em qual acols devo atribuir? se for data maior que hoje é na pasta 3, do contrário na pasta 1.
		If M->UC_PENDENT > MsDate()
			noPasta := nAba
			ndPasta := 3
		Else
			noPasta := nAba
			ndPasta := nAba
		Endif		
		//----------------------------------------------------
		// Atribuir o aCOLS atual para fazer update no objeto.
		//----------------------------------------------------
		coCOLS   := 'aCOLS' + LTrim( Str( noPasta ) )
		coHeader := 'aHeader' + LTrim( Str( noPasta ) )

		cdCOLS   := 'aCOLS' + LTrim( Str( ndPasta ) )
		cdHeader := 'aHeader' + LTrim( Str( ndPasta ) )

		//-----------------------------------------
		// Capturar a linha posicionada em questão.
		//-----------------------------------------
		nAt := &('oGride'+LTrim(Str(noPasta))+':nAt')
		//-----------------------------
		// Capturar a posição do campo.
		//-----------------------------
		nP_GD_LEGENDA := AScan( &(coHeader),{|p| p[2]=='GD_LEGENDA'} )
		nP_U6_DESCENT := AScan( &(coHeader),{|p| p[2]=='U6_DESCENT'} )
		nP_U6_DENTIDA := AScan( &(coHeader),{|p| p[2]=='U6_DENTIDA'} )
		nP_U4_RECNO   := AScan( &(coHeader),{|p| p[2]=='U4_RECNO'  } )
		nP_U5_RECNO   := AScan( &(coHeader),{|p| p[2]=='U5_RECNO'  } )
		nP_U6_RECNO   := AScan( &(coHeader),{|p| p[2]=='U6_RECNO'  } )
		nP_GD_ITEM    := AScan( &(coHeader),{|p| p[2]=='GD_ITEM'   } )
		nP_GD_GLOBAL  := AScan( &(coHeader),{|p| p[2]=='GD_GLOBAL' } )
		nP_U4_CODLIG  := AScan( &(coHeader),{|p| p[2]=='U4_CODLIG' } )
		nP_U4_DESC    := AScan( &(coHeader),{|p| p[2]=='U4_DESC'   } )
		nP_U5_CONTAT  := AScan( &(coHeader),{|p| p[2]=='U5_CONTAT' } )
		nP_U6_ENTIDA  := AScan( &(coHeader),{|p| p[2]=='U6_ENTIDA' } )
		//------------------------------
		// Capturar o número de colunas.
		//------------------------------
		nCol := Len( &(cdHeader) ) + 1
		//--------------------------------------
		// Adicionar um novo elemento na matriz.
		//--------------------------------------
		AAdd( &(cdCOLS), Array( nCol ) )
		//-------------------------------------------------
		// Capturar o número da linha adicionada na matriz.
		//-------------------------------------------------
		nLin := Len( &(cdCOLS) )
		//----------------------------------------------------------------------------------
		// Processar o aHeader para alimentar o aCOLS conforme o posicionamento das tabelas.
		//----------------------------------------------------------------------------------
		For nI := 1 To Len( &(coHeader) )
			//-----------------------------------
			// Processar somente os campos reais.
			//-----------------------------------
			If &(coHeader)[nI,10] <> 'V'
				cPref := SubStr( &(coHeader)[nI,2], 1, 2 )
				If cPref == 'U4'
					cCampo := 'SU4->'+&(coHeader)[nI,2]
				Elseif cPref == 'U5'
					cCampo := 'SU5->'+&(coHeader)[nI,2]
				Elseif cPref == 'U6'
					cCampo := 'SU6->'+&(coHeader)[nI,2]
				Endif
				cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nI))+'] := '+cCampo+' }'
				Eval(&cBlock)
			Endif
		Next nI
		
		//------------------------------------
		// Atribui a legenda campo GD_LEGENDA.
		//------------------------------------
		cLegenda := &(cdCOLS)[nLin,nP_U4_CODLIG] 
		cGD_LEGENDA := "'"+IIF(Empty(cLegenda),NAO_E_RETORNO,SIM_E_RETORNO)+"'"
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_GD_LEGENDA))+'] := '+cGD_LEGENDA+' }'
		Eval(&cBlock)
		
		//----------------------------
		// Atribui o nome da entidade.
		//----------------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_U6_DESCENT))+'] := '+coCOLS+'['+LTrim(Str(nAt))+','+LTrim(Str(nP_U6_DESCENT))+'] }'
		Eval(&cBlock)

		//-----------------------------
		// Atribui a sigla da entidade.
		//-----------------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_U6_DENTIDA))+'] := '+coCOLS+'['+LTrim(Str(nAt))+','+LTrim(Str(nP_U6_DENTIDA))+'] }'
		Eval(&cBlock)
		
		//----------------------
		// Atribuir o recno SU4.
		//----------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_U4_RECNO))+'] := '+LTrim(Str(SU4->(RecNo())))+' }'
		Eval(&cBlock)
		
		//----------------------
		// Atribuir o recno SU5.
		//----------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_U5_RECNO))+'] := '+LTrim(Str(SU5->(RecNo())))+' }'
		Eval(&cBlock)
		
		//----------------------
		// Atribuir o recno SU6.
		//----------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_U6_RECNO))+'] := '+LTrim(Str(SU6->(RecNo())))+' }'
		Eval(&cBlock)
		
		//-------------------------------------------
		// Atribui a chave global no campo GD_GLOBAL.
		//-------------------------------------------
		cGlobal := "'"+RTrim(&(cdCOLS)[nLin,nP_U4_DESC])+RTrim(&(cdCOLS)[nLin,nP_U5_CONTAT])+RTrim(&(cdCOLS)[nLin,nP_U6_DESCENT])+RTrim(&(cdCOLS)[nLin,nP_U6_DENTIDA])+"'"
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_GD_GLOBAL))+'] := '+cGlobal+' }'
		Eval(&cBlock)

		//-----------------------------------------
		// Atribuir o número do item campo GD_ITEM.
		//-----------------------------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nP_GD_ITEM))+'] := '+LTrim(Str(nLin))+' }'
		Eval(&cBlock)

		//-------------------------------------------------------------------------
		// Atribuir o valor falso para o controle de exclusão da linha da getdados.
		//-------------------------------------------------------------------------
		cBlock := '{|| '+cdCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nCol))+'] := .F. }'
		Eval(&cBlock)

		//-------------------------------------------------------
		// Passar o aCOLS atualizado para a classe MsNewGetDados.
		//-------------------------------------------------------
		cGride := 'oGride'+LTrim(Str(ndPasta))+':SetArray('+cdCOLS+',.T.)'
		&(cGride)
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A110AtuGetD  | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar a MsNewGetDados em questão.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110AtuGetD(nAba,oGride)
	Local lDel := .T.
	Local nLin := 0
	Local cBlock := ''
	
	nLin := oGride:nAt
	nCol := Len(oGride:aCOLS[1])
	cCOLS := 'aCOLS'+LTrim(Str(nAba))
	cBlock := '{|| '+cCOLS+'['+LTrim(Str(nLin))+','+LTrim(Str(nCol))+'] := .T. }'
	Eval(&cBlock)
	
	lDel := oGride:lDelete
	oGride:lDelete := .T.
	oGride:DelLine()
	oGride:lDelete := lDel
	oGride:oBrowse:SetFocus()
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A110TudOK    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se os campos de preenchimento obrigatório
//        | foram preenchidos, validar os campos necessários e se for
//        | encerramento 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110TudOK(aCpoCfg,oGetDa)
	Local lRet := .F.
	If A110Obrig(aCpoCfg,oGetDa)
		If A110Valid()
			If M->UD_STATUS == '1'
				lRet := .T.
			Elseif M->UD_STATUS == '2'
				If A110Encerr()
					lRet := .T.
				Endif
			Else
				MsgInfo('Opção de encerramento UD_STATUS inprevisto.',cCadastro)
			Endif
		Endif
   Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Obrig    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para criticar os campos obrigatórios não preenchidos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Obrig(aCpoCfg,oGetDa)
	Local lRet := .T.
	Local nI := 0
	Local cCpo := ''
	For nI := 1 To Len( aCpoCfg )
		If aCpoCfg[nI,5]
			cCpo := 'M->'+aCpoCfg[nI,1]
			If Empty( &(cCpo) )
				MsgInfo('O campo '+aCpoCfg[nI,2]+' é de preenchimento obrigatório.',cCadastro)
				lRet := .F.
				Exit
			Endif
		Endif
	Next nI	
	
	If Len(oGetDa:aCols) == 0
		lRet := .F.
		MsgInfo('Por favor preencha o produto.',cCadastro)
	Else
		For nQ := 1 to Len(oGetDa:aCols)
			
			If Empty(oGetDa:aCols[nQ, AScan(oGetDa:aHeader, {|p| p[2]=='UD_PRODUTO'})])
				lRet := .F.
				MsgInfo('Por favor preencha o produto no item '+AllTrim(Str(nQ)),cCadastro)
			ElseIf Empty(oGetDa:aCols[nQ, AScan(oGetDa:aHeader, {|p| p[2]=='UD_QUANT'})])
				lRet := .F.
				MsgInfo('Por favor preencha a quantidade no item '+AllTrim(Str(nQ)),cCadastro)
			ElseIf Empty(oGetDa:aCols[nQ, AScan(oGetDa:aHeader, {|p| p[2]=='UD_VUNIT'})])
				lRet := .F.
				MsgInfo('Por favor preencha o valor unitário no item '+AllTrim(Str(nQ)),cCadastro)
			EndIf

		Next
	EndIf
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Valid    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar o preenchimento do atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Valid()
	Local lRet := .F.
	Local cHrIni := '08:00:00'
	Local cHrFim := '20:00:00'
	Local cTime := Time()
	
	If M->UD_STATUS=='1' //Pendente
		If Empty(M->UC_PENDENT) .Or. Empty(M->UC_HRPEND)
			MsgAlert('O Status do Assunto foi informando como pendente, por isso precisa haver Data de Retorno e Hora de Retorno.',cCadastro)
		Else
			M->UC_HRPEND := M->UC_HRPEND + ':00'
			If M->UC_PENDENT >= MsDate()
				//---------------------------------------------------------------------------------------
				// A data do reagendamento informado é igual a data atual?  Então validar somente a hora.
				//---------------------------------------------------------------------------------------
				If M->UC_PENDENT == MsDate()
					//----------------------------------------------------------------------
					// A hora informada é maior que a hora atual e menor que o limite final?
					//----------------------------------------------------------------------
					If M->UC_HRPEND > cTime .And. M->UC_HRPEND < cHrFim
						lRet := .T.
					Else
						MsgInfo('A hora do reagendamento informado não pode ser menor que a hora atual '+cTime+', e nem maior que '+cHrFim+' reavalie.',cCadastro)
					Endif	
				Else
					//-------------------------------------------------------------------------------------------------------------------------------------------
					// A data do reagendamento sendo maior que a data atual, validar se a hora do reagendamento informado é maior que os limites inicial e final.
					//-------------------------------------------------------------------------------------------------------------------------------------------
					If M->UC_HRPEND >= cHrIni .And. M->UC_HRPEND <= cHrFim
						lRet := .T.
					Else
						MsgInfo('A hora do reagendamento informado não pode ser menor que '+cHrIni+', e nem maior que '+cHrFim+' reavalie.',cCadastro)
					Endif
				Endif
			Else
				MsgInfo('A data do reagendamento não pode ser menor que a data de hoje, reavalie.',cCadastro)
			Endif
		Endif
	Else
		lRet := .T.
	Endif	
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Encerr   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina apresentar a interface de código de encerramento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Encerr()
	Local lRet := .T.
	Local aPar := {}
	Local bOK := {|| Iif(!Empty(aRetEncer[2]).And.!Empty(aRetEncer[2]),MsgYesNo('Confirma o encerramento?',cCadastro),.F.) }
	Private l110Encerr := .T.
	AAdd(aPar,{1,"Código do encerramento",Space(Len(SUN->UN_ENCERR)),"","ExistCpo('SUN').And.U_A110Gat01()","SUN","",50,.T.})
	AAdd(aPar,{11,"Complemento da descrição","",".T.",".T.",.T.})
	lRet := ParamBox(aPar,'Encerramento',@aRetEncer,bOK,,,,,,,.F.,.F.)
	If !lRet
		MsgInfo('Operação para informar o código do encerramento foi abandonada.',cCadastro)
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110Gat01    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para executar os gatilhos dos campos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110Gat01(cOrigem)
	Local cMemVar := ''
	Local cCampo := ''
	Local cRet := ''
	Local lRet := .T.
	
	Default cOrigem := ''
	
	cMemVar := ReadVar()
	cCampo := RTrim(SubStr(cMemVar,4))
	
   If cCampo == 'UD_ASSUNTO'
   	cRet := SX5->(Posicione('SX5',1,xFilial('SX5')+'T1'+&(cMemVar),'X5_DESCRI'))
   	M->UD_DESCASS := cRet
   Elseif cCampo == 'UD_OCORREN'
   	cRet := RTrim(SU9->(Posicione('SU9',1,xFilial('SU9')+M->UD_ASSUNTO+&(cMemVar),'U9_DESC')))+' - '+;
   	        RTrim(SUX->(Posicione('SUX',1,xFilial('SUX')+SU9->(Posicione('SU9',1,xFilial('SU9')+M->UD_ASSUNTO+&(cMemVar),'U9_TIPOOCO')),'UX_DESTOC')))
   	M->UD_DESCOCO := cRet
   Elseif cCampo == 'UD_SOLUCAO'
   	cRet := SUR->UR_DESC
   	M->UD_DESCSOL := cRet
   Elseif cCampo == 'UC_TIPO'
   	cRet := &(cMemVar)
   	M->UC_TIPO := cRet
   	cRet := SUL->(Posicione('SUL',1,xFilial('SUL')+cRet,'UL_DESC'))
   	M->UC_DESCTIP := cRet
   Elseif cCampo == 'UD_PRODUTO' .Or. cOrigem == 'UD_PRODUTO'
   	cRet := SB1->(Posicione('SB1',1,xFilial('SB1')+&(cMemVar),'B1_DESC'))
   	M->UD_DESCPRO := cRet
   	If !Empty(cOrigem)
   		oGetDa:aCols[oGetDa:nAt, AScan(oGetDa:aHeader, {|p| p[2]=='UD_DESCPRO'})] := cRet
   	EndIf
   Elseif cCampo $ 'UD_QUANT|UD_VUNIT' .Or. cOrigem $ 'UD_QUANT|UD_VUNIT'
   	cRet := 'OK'
   	M->UD_TOTAL := M->UD_QUANT * M->UD_VUNIT
   	If !Empty(cOrigem)
   		oGetDa:aCols[oGetDa:nAt, AScan(oGetDa:aHeader, {|p| p[2]=='UD_TOTAL'})] := M->UD_QUANT * M->UD_VUNIT
   	EndIf
   Elseif cMemVar == 'MV_PAR01' .And. Type('l110Encerr')<>'U'
   	If l110Encerr 
   		cRet := RTrim(SUN->(Posicione('SUN',1,xFilial('SUN')+&(cMemVar),'UN_DESC')))+'.'
   		MV_PAR02 := cRet
   	Endif
   Endif
   If Empty(cRet)
   	lRet := .F.
   	Help('',1,'REGNOIS')
   Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110XBUR     | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ apresentar ocorrências conforme a ação selecionada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110XBUR()
	Local oDlgRec
	Local oLbx1
	Local aItems   := {}
	Local cIdTree  := ""
	Local cIdCode  := ""
	Local nPosLbx  := 0
	Local nPos     := 0
	Local nPOcorre := 0
	Local nCont    := 0
	Local nAchou   := 0
	Local lRet     := .F.
	
	cOcorrencia := M->UD_OCORREN
	
	SUR->(DbSetorder(1))
	SUR->(DbSeek(xFilial("SUR")+cOcorrencia))
	While !SUR->(EOF()) .AND. (xFilial("SUR") == SUR->UR_FILIAL) .AND. (SUR->UR_CODREC == cOcorrencia)
		If !Empty(SUR->UR_CODSOL)
			Aadd(aItems,{SUR->UR_CODSOL,;			// 1 - Codigo da Solucao
							SUR->UR_DESC,;          // 2 - Descricao 
							SUR->UR_IDTREE,;        // 3 - ID do TREE
							SUR->UR_IDCODE,;        // 4 - ID do codigo 
							SPACE(40),;             // 5 - Nome do responsavel
							SPACE(30)})             // 6 - e-mail do responsavel
			If M->UD_SOLUCAO==SUR->UR_CODSOL
				nAchou := Len(aItems)
			Endif
		Endif	
		SUR->(DbSkip())
	End  
	
	If Len(aItems) > 0 
		For nCont := 1 TO Len(aItems)
			SUQ->(DbSetorder(1))
			If SUQ->(DbSeek(xFilial("SUQ")+aItems[nCont][1]))
				aItems[nCont][6] := SUQ->UQ_EMAIL
				PswOrder(1)
				If PswSeek(SUQ->UQ_CODRESP)
					aUser:= PswRet(1)
					aItems[nCont][5] := aUser[1][2]
				Endif
			Endif
		Next nCont
			
		DEFINE MSDIALOG oDlgRec FROM 50,003 TO 260,730 TITLE "Ocorrencia X Ação - Vendas Diretas"  PIXEL		
			@ 03,04 LISTBOX oLbx1 VAR nPosLbx;
				FIELDS HEADER ;
				"Acao",;
				"Descricao",;
				"Responsável",;
				"E-Mail";
				SIZE 355,80 OF oDlgRec PIXEL NOSCROLL 
				oLbx1:SetArray(aItems)
				oLbx1:bLine:={|| {aItems[oLbx1:nAt,1],;// Codigo da Acao
										aItems[oLbx1:nAt,2],;// Descricao da Acao
										aItems[oLbx1:nAt,5],;// Responsavel 
										aItems[oLbx1:nAt,6]}}// Email
		
			oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgRec:End())}
			oLbx1:Refresh()
			If nAchou > 0
				oLbx1:nAt := nAchou
			Endif
		    
			DEFINE SBUTTON FROM 88,300 TYPE 1 ENABLE OF oDlgRec ACTION (lRet:= .T.,nPos:= oLbx1:nAt,oDlgRec:End())
			DEFINE SBUTTON FROM 88,335 TYPE 2 ENABLE OF oDlgRec ACTION (lRet:= .F.,oDlgRec:End())		
		ACTIVATE MSDIALOG oDlgRec CENTERED
		
		If lRet
		   cIdTree := aItems[nPos][3]
		   cIdCode := aItems[nPos][4]
		   SUR->(DbSetorder(1))
		   SUR->(DbSeek(xFilial("SUR")+cOcorrencia+cIdTree+cIdCode))
		Endif	
	Else
	   Help(" ",1,"FALTA_ACAO")
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | SUR110       | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ criar a estrut. da consulta SXB ocorrência x ações.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function SUR110()
	Local aDados := {}
	AAdd(aDados,{'SUR110','1','01','RE','Ocorrencia X Acao','Ocorrencia X Acao','Ocorrencia X Acao','SUR'           ,''})
	AAdd(aDados,{'SUR110','2','01','01','Codigo'           ,'Codigo'           ,'Codigo'           ,'U_A110XBUR()'  ,''})
	AAdd(aDados,{'SUR110','5','01',''  ,''                 ,''                 ,''                 ,'SUR->UR_CODSOL',''})
	A110SXB(aDados)
Return

//-----------------------------------------------------------------------
// Rotina | A110Tentat   | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ apresentar as tentativas de ligação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Tentat(nAba,oGride)
	Local nP := 0
	
	Local cOcorr      := ''
	Local cU4_LISTA   := ''
	Local cU6_CONTATO := ''
	
	Local aOCORR := {}
	
	Local oDlg := NIL
	Local oLbx := NIL
	
	If A110IsDel(oGride)
		Return
	Endif

	If !Empty(aSTADISC)
		cU4_LISTA   := oGride:aCOLS[ oGride:nAt, AScan(oGride:aHeader, {|p| p[2]=='U4_LISTA'}) ]
		cU6_CONTATO := oGride:aCOLS[ oGride:nAt, AScan(oGride:aHeader, {|p| p[2]=='U6_CONTATO'}) ]
		If !Empty(cU4_LISTA) .And. !Empty(cU6_CONTATO)
			SU8->(dbSetOrder(1))
			SU8->(dbSeek(xFilial('SU8')+cU4_LISTA+cU6_CONTATO))
			While !SU8->(EOF()) .And. SU8->(U8_FILIAL+U8_CRONUM+U8_CONTATO) == xFilial('SU8')+cU4_LISTA+cU6_CONTATO
				nP := AScan(aSTADISC,{|p| SubStr(p,1,1)==SU8->U8_STATUS})
				If nP > 0
					cOcorr := SubStr(aSTADISC[nP],3)
				Else
					cOcorr := '*** Opção de tentativa não localizada ***'
				Endif
				SU8->(AAdd(aOCORR,{ U8_CRONUM, U8_DATA, U8_HROCOR, cOcorr, '' }))
				SU8->(dbSkip())
			End
			If Len(aOCORR)>0
				DEFINE MSDIALOG oDlg TITLE 'Tentativas de discagem' FROM 0,0 TO 240,500 PIXEL
					oDlg:bLClicked:= {|| oDlg:End()}
					
				   oLbx := TwBrowse():New(0,0,0,0,,{'Cód.Lista','DT.Ocorr.','HR.Ocorr.','Ocorrência registrada',''},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
				   oLbx:bLClicked:= {|| oDlg:End() }
				   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
				   oLbx:SetArray( aOCORR )
				   oLbx:bLine := {|| AEval( aOCORR[oLbx:nAt],{|z,w| aOCORR[oLbx:nAt,w]}) }
				ACTIVATE MSDIALOG oDlg CENTER 
			Else
				MsgInfo('Não localizado nenhuma tentativa de discagem para esta agenda.',cCadastro)
			Endif
		Else
			MsgInfo('Não localizado o número da lista e o código do contato.',cCadastro)
		Endif
	Else
		MsgInfo('Não localizado as opções de tentativas na variável aSTATDISC do parâmetro MV_STADISC.',cCadastro)
	Endif
	oGride:oBrowse:SetFocus()
Return

//-----------------------------------------------------------------------
// Rotina | A110IsDel    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ varificar se a linha em questão está atendida.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110IsDel(oGride)
	Local lRet := .F.
	If oGride:aCOLS[ oGride:nAt, Len( oGride:aCOLS[ oGride:nAt ] ) ]
		lRet := .T.
		MsgInfo('Agenda já atendida, por favor, selecione outra agenda.',cCadastro)
	Endif
	oGride:oBrowse:SetFocus()
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A110XBU9     | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo F3 do campo UD_OCORRENCIA.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110XBU9()
	Local oDlgSu9
	Local oLbx1
	Local aItems    := {}
	Local nPosLbx   := 0
	Local nPos      := 0
	Local nPAssunto := 0
	Local nAchou    := 0
	Local cAssunto  := ""
	Local lRet      := .F.
	Local cSQL      := ''
	Local cTRB      := ''
	
	cAssunto := M->UD_ASSUNTO
	
	cSQL := "SELECT U9_CODIGO, "
	cSQL += "       U9_DESC, "
	cSQL += "       U9_TIPOOCO, "
	cSQL += "       UX_DESTOC "
	cSQL += "FROM   "+RetSqlName("SU9")+" SU9 "
	cSQL += "       INNER JOIN "+RetSqlName("SUX")+" SUX "
	cSQL += "               ON UX_FILIAL = "+ValtoSql(xFilial("SUX"))+" "
	cSQL += "                  AND UX_CODTPO = U9_TIPOOCO "
	cSQL += "                  AND SUX.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  U9_FILIAL = "+ValToSql(xFilial("SU9"))+" "
	cSQL += "       AND U9_ASSUNTO = "+ValToSql(cAssunto)+" "
	cSQL += "       AND U9_CODIGO <> ' ' "
	cSQL += "       AND U9_VALIDO <> '2' "
	cSQL += "       AND SU9.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY UX_DESTOC,U9_CODIGO "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	While ! (cTRB)->( EOF() )
		(cTRB)->(AAdd(aItems,{U9_CODIGO,U9_DESC,U9_TIPOOCO,UX_DESTOC}))
		If M->UD_OCORREN==(cTRB)->U9_CODIGO
			nAchou := Len(aItems)
		Endif
		(cTRB)->( dbSkip() )
	End
	(cTRB)->(dbCloseArea())
	
	If Len(aItems) <= 0
	   Help(" ",1,"FALTA_OCOR")
	   Return(lRet)
	Endif	
		
	DEFINE MSDIALOG oDlgSu9 FROM 50,3 TO 260,730 TITLE "Ocorrências Relacionadas - Vendas Diretas" PIXEL 
		@ 3,4 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER ;
				"Ocorrência",;
				"Descrição",;
				"Tipo ocorrência",;
				"Descrição tipo ocorrência";
				SIZE 355,80 OF oDlgSu9 PIXEL NOSCROLL
		oLbx1:SetArray(aItems)
	   oLbx1:bLine:={||{aItems[oLbx1:nAt,1],;
						 aItems[oLbx1:nAt,2],;
						 aItems[oLbx1:nAt,3],;
						 aItems[oLbx1:nAt,4] }}
	
	   oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgSu9:End())}
		oLbx1:Refresh()
		If nAchou > 0
			oLbx1:nAt := nAchou
		Endif
		
	   DEFINE SBUTTON FROM 88,300 TYPE 1 ENABLE OF oDlgSu9 ACTION (lRet:= .T.,nPos := oLbx1:nAt,oDlgSu9:End())
	   DEFINE SBUTTON FROM 88,335 TYPE 2 ENABLE OF oDlgSu9 ACTION (lRet:= .F.,oDlgSu9:End())
	ACTIVATE MSDIALOG oDlgSu9 CENTERED
	
	If lRet
	   DbSelectarea("SU9")
	   DbSetorder(1)
	   IF DbSeek(xFilial("SU9")+cAssunto+aItems[nPos][1])
	      M->UD_OCORREN := SU9->U9_CODIGO
	   ENDIF
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | SU9110       | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ criar a estrutura da consulta SXB Ocorrências.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function SU9110()
	Local aDados := {}
	AAdd(aDados,{'SU9110','1','01','RE','Ocorrencia','Ocorrencia','Ocorrencia','SU9'           ,''})
	AAdd(aDados,{'SU9110','2','01','01','Codigo'    ,'Codigo'    ,'Codigo'    ,'U_A110XBU9()'  ,''})
	AAdd(aDados,{'SU9110','5','01',''  ,''          ,''          ,''          ,'SU9->U9_CODIGO',''})
	A110SXB(aDados)
Return

//-----------------------------------------------------------------------
// Rotina | T1_110       | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ criar a estrutura da consulta SXB Assuntos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function T1_110()
	Local aDados := {}	
	AAdd(aDados,{'T1_110','1','01','RE','Assuntos','Assuntos','Assunto','SX5'           ,''})
	AAdd(aDados,{'T1_110','2','01','01','Codigo'  ,'Codigo'  ,'Codigo' ,'U_A110XBT1()'  ,''})
	AAdd(aDados,{'T1_110','5','01',''  ,''        ,''        ,''       ,'SX5->X5_CHAVE' ,''})
	A110SXB(aDados)
Return

//-----------------------------------------------------------------------
// Rotina | A110SXB      | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ criar a estrutura da consulta SXB específica.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110SXB(aDados)
	Local aCpoXB := {}
	Local nI     := 0
	Local nJ     := 0

	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}

	SXB->(dbSetOrder(1))
	For nI := 1 To Len( aDados )
		If !SXB->(dbSeek(aDados[nI,1]+aDados[nI,2]+aDados[nI,3]+aDados[nI,4]))
			SXB->(RecLock('SXB',.T.))
			For nJ := 1 To Len( aDados[nI] )
				SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aDados[nI,nJ]))
			Next nJ
			SXB->(MsUnLock())
		Endif
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A110XBT1     | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo F3 do campo UD_ASSUNTO
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110XBT1()
	Local oDlg
	Local oLbx1
	Local aItems      := {}
	Local nPosLbx     := 0
	Local nPos        := 0
	Local nPAssunto   := 0
	Local nAchou      := 0
	Local lRet        := .F.
	Local cMV_110X5T1 := 'MV_110X5T1'
	
	If .NOT. SX6->( ExisteSX6( cMV_110X5T1 ) )
		CriarSX6( cMV_110X5T1, 'C', 'CHAVE DE BUSCA DOS CODIGOS DA TABELA DE ASSUNTO. CSFA110.prw', 'VDS%' )
	Endif
	cMV_110X5T1 := RTrim( GetMv( cMV_110X5T1 ) )

	cSQL := "SELECT X5_TABELA, "
	cSQL += "       X5_CHAVE, "
	cSQL += "       X5_DESCRI "
	cSQL += "FROM   "+RetSqlName("SX5")+" " 
	cSQL += "WHERE  X5_FILIAL = "+ValToSql(xFilial("SX5"))+" "
	cSQL += "       AND X5_TABELA = 'T1' "
	cSQL += "       AND X5_CHAVE LIKE "+ValToSql( cMV_110X5T1 )+" "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "ORDER BY X5_FILIAL,X5_DESCRI, X5_TABELA, X5_CHAVE "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	While ! (cTRB)->( EOF() )
		(cTRB)->(AAdd(aItems,{X5_TABELA,X5_CHAVE,X5_DESCRI}))
		If M->UD_ASSUNTO == RTrim((cTRB)->(X5_CHAVE))
			nAchou := Len( aItems )
		Endif
		(cTRB)->( dbSkip() )
	End
	(cTRB)->(dbCloseArea())
	
	If Len(aItems) <= 0
	   Help(" ",1,"REGNOIS")
	   Return(lRet)
	Endif
	
	DEFINE MSDIALOG oDlg FROM 50,3 TO 260,730 TITLE "Assuntos - Vendas Diretas" PIXEL	
		@ 3,4 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER "Chave","Código do assunto","Descrição do assunto" SIZE 355,80 OF oDlg PIXEL
		oLbx1:SetArray(aItems)
	   oLbx1:bLine:={||{aItems[oLbx1:nAt,1],aItems[oLbx1:nAt,2],aItems[oLbx1:nAt,3] }}
	   oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlg:End())}
		oLbx1:Refresh()
		If nAchou > 0
			oLbx1:nAt := nAchou
		Endif
		
	   DEFINE SBUTTON FROM 88,300 TYPE 1 ENABLE OF oDlg ACTION (lRet:= .T.,nPos := oLbx1:nAt,oDlg:End())
		DEFINE SBUTTON FROM 88,335 TYPE 2 ENABLE OF oDlg ACTION (lRet:= .F.,oDlg:End())	
	ACTIVATE MSDIALOG oDlg CENTERED	
	If lRet
	   DbSelectarea("SX5")
	   DbSetorder(1)
	   IF DbSeek(xFilial("SX5")+'T1'+aItems[nPos][2])
	      M->UD_ASSUNTO := SX5->X5_CHAVE
	   ENDIF
	Endif
Return(lRet)

//------------------------------------------------------------------
// Rotina | A110Filtro | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina para formular filtros específicos, ou seja,
//        | filtros pré-estabelecidos.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A110Filtro(oBtnA1)
	Local aPar       := {}
	Local aRet       := {}	
	Local nFilAgenda := 0
	Local nFilEntida := 0
	Local aFilAgenda := {'Todas','Sem retorno','Com retorno'}
	Local aFilEntida := {'Todas', 'Renovação SSL', 'Renovação ICP', 'Importação de Listas', 'Clientes', 'Prospects', 'Suspects'}
	Local aNomLista  := {'Todas','Renovação','Ativação','Outros'}
	Local aPrior	   := {'Todas','Baixa','Alta'}
	Local dExpirDe   := Ctod(Space(8))
	Local dExpirAte  := Ctod(Space(8))
	Local cContato   := ''
	Local cEmpresa   := ''
	Local nNomLista  := 0
	Local cContem    := ''
	Local nPriori    := 1
	
	If Len( a110Fil[ 5 ] ) < 50
		a110Fil[ 5 ] := PadR( a110Fil[ 5 ], 50, ' ' )
	Endif
	
	If Len( a110Fil[ 6 ] ) < 50
		a110Fil[ 6 ] := PadR( a110Fil[ 6 ], 50, ' ' )
	Endif
	
	AAdd( aPar ,{2 ,'Filtrar agendas'          ,a110Fil[ 1 ] ,aFilAgenda ,80                     ,'' ,.F.             } )
	AAdd( aPar ,{2 ,'Filtrar entidades'        ,a110Fil[ 2 ] ,aFilEntida ,80                     ,'' ,.F.             } )
	AAdd( aPar ,{1 ,'DT. Expira de'            ,a110Fil[ 3 ] ,''         ,''                     ,'' ,''    ,50  ,.F. } )
	AAdd( aPar ,{1 ,'DT. Expira até'           ,a110Fil[ 4 ] ,''         ,'(mv_par04>=mv_par03)' ,'' ,''    ,50  ,.F. } )
	AAdd( aPar ,{1 ,'Nome do contato'          ,a110Fil[ 5 ] ,'@!'       ,''                     ,'' ,''    ,120 ,.F. } )
	AAdd( aPar ,{1 ,'Nome da Empresa/Entidade' ,a110Fil[ 6 ] ,'@!'       ,''                     ,'' ,''    ,120 ,.F. } )
	AAdd( aPar ,{2 ,'Nome da Lista'            ,a110Fil[ 7 ] ,aNomLista  ,80                     ,'' ,.F.             } )
	AAdd( aPar ,{1 ,"Outros - Especifique"     ,a110Fil[ 8 ] ,"@"        ,'.T.'                  ,   ,'.T.' ,40  ,.F. } )
	AAdd( aPar ,{2 ,'Prioridade   '            ,a110Fil[ 9 ] ,aPrior     ,80                     ,'' ,.F.             } )
		
	If ParamBox(aPar,'Filtrar...',@aRet)
		nFilAgenda := Iif( ValType( aRet[ 1 ] ) == 'N',aRet[ 1 ], AScan( aFilAgenda, {|e| e==aRet[ 1 ] } ) )
		nFilEntida := Iif( ValType( aRet[ 2 ] ) == 'N',aRet[ 2 ], AScan( aFilEntida, {|e| e==aRet[ 2 ] } ) )
		dExpirDe   := aRet[3]
		dExpirAte  := aRet[4]
		cContato   := RTrim( aRet[5] )
		cEmpresa   := RTrim( aRet[6] )
		nNomLista  := Iif( ValType( aRet[ 7 ] ) == 'N',aRet[ 7 ], AScan( aNomLista, {|e| e==aRet[ 7 ] } ) )
		cContem    := Upper(aRet[8])
		nPriori    := Iif( ValType( aRet[ 9 ] ) == 'N',aRet[ 9 ], AScan( aPrior, {|e| e==aRet[ 9 ] } ) )
		a110Fil[ 1 ] := nFilAgenda
		a110Fil[ 2 ] := nFilEntida
		a110Fil[ 3 ] := dExpirDe
		a110Fil[ 4 ] := dExpirAte
		a110Fil[ 5 ] := cContato
		a110Fil[ 6 ] := cEmpresa
		a110Fil[ 7 ] := nNomLista
		a110Fil[ 8 ] := cContem 
		a110Fil[ 9 ] := nPriori
		If A110LoadAg( nFilAgenda, nFilEntida, dExpirDe, dExpirAte, cContato, cEmpresa, nNomLista, cContem, nPriori )
			If nFilAgenda > 1 .Or. ;
			   nFilEntida > 1 .Or. ;
			   .NOT.Empty( dExpirDe ) .Or. ;
			   .NOT.Empty( dExpirAte ) .Or. ;
			   .NOT.Empty(cContato ) .Or. ;
			   .NOT.Empty(cEmpresa ) .Or. ;
			   nNomLista > 1 .Or.;
			   nPriori > 1
				oBtnA1:cCaption := '<<< Filtrado >>>'
			Else
				oBtnA1:cCaption := 'Filtrar'
			Endif
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A110Script | Autor | Robson Gonçalves     | Data | 17.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Script( cSQL )
	Local cNomeArq := ''
	Local nHandle  := 0
	Local lEmpty   := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return

//------------------------------------------------------------------
// Rotina | A110Edit   | Autor | Robson Luiz -Rleg | Data | 30/08/13
//------------------------------------------------------------------
// Descr. | Rotina para permitir a edição do campo UD_QUANT e
//        | UD_VUNIT quando o código de produto for informado.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function A110Edit( cField )
	Local lRet := .T.
	If SubStr(cField,4) $ 'UD_QUANT|UD_VUNIT'
		If Empty( aCOLS[ n, AScan( aHeader, {|p| p[2]=='UD_PRODUTO'}) ] )
			lRet := .F.
		Endif
	Endif
Return( lRet )

//------------------------------------------------------------------
// Rotina | A110ChgSX6 | Autor | Robson Luiz -Rleg | Data | 24/09/13
//------------------------------------------------------------------
// Descr. | Rotina para permitir alterar os parâmetros SX6 da Agenda
//        | Certisign
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A110ChgSX6()
	Local oDlg
	Local oLbx
	Local oPanel 
	Local nI := 0
	Local aSX6 := {}
	Private aDadosSX6 := {}
	aSX6 := {'MV_DTAGEND','MV_STADISC','MV_STATVLD','MV_110VIEW','MV_110DIM','MV_110X5T1','MV_TSDISCA','MV_XDIAAGE','MV_XAVIAGE','MV_XGEROPO','MV_XAGETF','MV_XAGETLV'}
	
	SX6->( dbGotop() )
	SX6->( dbSetOrder( 1 ) )
	SX6->( dbSeek( xFilial('SX6') + 'AGOP') ) 
	While .NOT. SX6->( Eof() ) .And. 'AGOP' $ SX6->X6_VAR
		aADD( aSX6, SX6->X6_VAR )
		SX6->( dbSkip() )
	End
	
	SX6->( dbGotop() )
	SX6->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSX6 )
		If SX6->( dbSeek( xFilial( 'SX6' ) + aSX6[ nI ] ) )
			SX6->( AAdd( aDadosSX6, { X6_VAR, X6_TIPO, X6_CONTEUD, Capital(RTrim(X6_DESCRIC)+' '+RTrim(X6_DESC1)+' '+RTrim(X6_DESC2)) } ) )
		Endif
	Next nI
	If Len( aDadosSX6 ) > 0
		ASort( aDadosSX6, , , {|a,b| a[ 1 ] < b[ 1 ] } )
		DEFINE MSDIALOG oDlg TITLE 'Parâmetros Agenda Certisign' FROM 0,0 TO 200,800 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'Parâmetro','Tipo','Conteúdo','Descrição'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDadosSX6 )
		   oLbx:bLine := {|| aEval( aDadosSX6[oLbx:nAt],{|z,w| aDadosSX6[oLbx:nAt,w]})}
		   oLbx:BlDblClick := {|| A110EdtSX6( @oLbx ) }

			oPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
		
			@ 04,04 BUTTON "&Editar" SIZE 36,10 OF oPanel PIXEL ACTION A110EdtSX6( @oLbx )
			@ 04,44 BUTTON "&Sair"   SIZE 36,10 OF oPanel PIXEL ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert( 'Parâmetro não localizado.',cCadastro )
	Endif
Return

//------------------------------------------------------------------
// Rotina | A110EdtSX6 | Autor | Robson Luiz -Rleg | Data | 24/09/13
//------------------------------------------------------------------
// Descr. | Rotina para editar e gravar o conteúdo do parâmetro SX6.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function A110EdtSX6( oLbx )
	Local aPar := {}
	Local aRet := {}
	Local cX6_VAR := aDadosSX6[ oLbx:nAt, 1 ]
	Local cX6_CONTEUD := RTrim( aDadosSX6[ oLbx:nAt, 3 ] )
	AAdd( aPar,{ 1, 'Conteúdo do parâmetro',(cX6_CONTEUD + Space( 250 - Len( cX6_CONTEUD ) )),'','','','',120,.F.})
	If ParamBox( aPar,'Parâmetros Agenda Certisign', @aRet )
		If Upper( cX6_CONTEUD ) <> Upper( RTrim( aRet[ 1 ] ) )
			PutMv( cX6_VAR, aRet[ 1 ] )
			aDadosSX6[ oLbx:nAt, 3 ] := aRet[ 1 ]
			oLbx:Refresh()
			MsgInfo('Parâmetro modificado com sucesso', cCadastro )
		Endif
	Endif
Return

/* Função para modificar a ordem do campo */
User Function UPD110A()
	If MsgYesNo('Confirma a reorganização dos campos da SUD e criação dos gatilhos UD_QUANT, UD_VUNIT em UD_TOTAL?','UPD110A')
		FwMsgRun(, {|| A110Upd() }, , 'Mudando as ordens dos campos...')
	Endif
Return
Static Function A110Upd()
	NGAltConteu('SX3','UD_FILIAL ',2,'X3_ORDEM','01')
	NGAltConteu('SX3','UD_CODIGO ',2,'X3_ORDEM','02')
	NGAltConteu('SX3','UD_ITEM   ',2,'X3_ORDEM','03')
	NGAltConteu('SX3','UD_ASSUNTO',2,'X3_ORDEM','04')
	NGAltConteu('SX3','UD_DESCASS',2,'X3_ORDEM','05')
	NGAltConteu('SX3','UD_PRODUTO',2,'X3_ORDEM','06')
	NGAltConteu('SX3','UD_DESCPRO',2,'X3_ORDEM','07')
	NGAltConteu('SX3','UD_QUANT  ',2,'X3_ORDEM','08')
	NGAltConteu('SX3','UD_VUNIT  ',2,'X3_ORDEM','09')
	NGAltConteu('SX3','UD_TOTAL  ',2,'X3_ORDEM','10')
	NGAltConteu('SX3','UD_OCORREN',2,'X3_ORDEM','11')
	NGAltConteu('SX3','UD_DESCOCO',2,'X3_ORDEM','12')
	NGAltConteu('SX3','UD_SOLUCAO',2,'X3_ORDEM','13')
	NGAltConteu('SX3','UD_DESCSOL',2,'X3_ORDEM','14')
	NGAltConteu('SX3','UD_OPERADO',2,'X3_ORDEM','15')
	NGAltConteu('SX3','UD_DESCOPE',2,'X3_ORDEM','16')
	NGAltConteu('SX3','UD_DATA   ',2,'X3_ORDEM','17')
	NGAltConteu('SX3','UD_STATUS ',2,'X3_ORDEM','18')
	NGAltConteu('SX3','UD_OBS    ',2,'X3_ORDEM','19')
	NGAltConteu('SX3','UD_DTEXEC ',2,'X3_ORDEM','20')
	NGAltConteu('SX3','UD_CODEXEC',2,'X3_ORDEM','21')
	NGAltConteu('SX3','UD_OBSEXEC',2,'X3_ORDEM','22')
	NGAltConteu('SX3','UD_CODFNC ',2,'X3_ORDEM','23')
	NGAltConteu('SX3','UD_FNCREV ',2,'X3_ORDEM','24')
	NGAltConteu('SX3','UD_EVENTO ',2,'X3_ORDEM','25')
	NGAltConteu('SX3','UD_GRADE  ',2,'X3_ORDEM','26')
	NGAltConteu('SX3','UD_NSERIE ',2,'X3_ORDEM','27')
	NGAltConteu('SX3','UD_NUMOS  ',2,'X3_ORDEM','28')
	NGAltConteu('SX3','UD_COMPORI',2,'X3_ORDEM','29')
	NGAltConteu('SX3','UD_CODCORI',2,'X3_ORDEM','30')
	NGAltConteu('SX3','UD_ORIGEM ',2,'X3_ORDEM','31')
	NGAltConteu('SX3','UD_VENDA  ',2,'X3_ORDEM','32')
	NGAltConteu('SX3','UD_ITEMVDA',2,'X3_ORDEM','33')
	NGAltConteu('SX3','UD_LSTCONT',2,'X3_ORDEM','34')	
	
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'UD_QUANT' ) )
		If SX3->X3_TRIGGER <> 'S'
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_TRIGGER := 'S'
			SX3->( MsUnLock() )
		Endif
	Endif
	
	If SX3->( dbSeek( 'UD_VUNIT' ) )
		If SX3->X3_TRIGGER <> 'S'
			SX3->( RecLock( 'SX3', .F. ) )
			SX3->X3_TRIGGER := 'S'
			SX3->( MsUnLock() )
		Endif
	Endif
	
	SX7->( dbSetOrder( 1 ) )
	If .NOT. SX7->( dbSeek( 'UD_QUANT  ' + '001' ) )
		SX7->( RecLock( 'SX7', .T. ) )
		SX7->X7_CAMPO   := 'UD_QUANT'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'M->UD_QUANT * M->UD_VUNIT'
		SX7->X7_CDOMIN  := 'UD_TOTAL'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'N'
		SX7->X7_PROPRI  := 'S'
		SX7->( MsUnLock() )
	Endif
	
	If .NOT. SX7->( dbSeek( 'UD_VUNIT  ' + '001' ) )
		SX7->( RecLock( 'SX7', .T. ) )
		SX7->X7_CAMPO   := 'UD_VUNIT'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'M->UD_QUANT * M->UD_VUNIT'
		SX7->X7_CDOMIN  := 'UD_TOTAL'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'N'
		SX7->X7_PROPRI  := 'S'
		SX7->( MsUnLock() )
	Endif
Return

/* Função para contemplar informação no campo U4_DTEXPIR baseado no campo U4_DESC.. */
User Function UPD110B()
	If MsgYesNo('Confirma a execução da atualização do campo U4_DTEXPIR baseado no campo U4_DESC?','UPD110B')
		FWMsgRun(,{|| B110Upd() },,'Aguarde, atualizando o campo U4_DTEXPIR...')
	Endif
Return
Static Function B110Upd()
	Local nP    := 0
	Local dData := Ctod(Space(8))
	Local cSQL  := ''
	Local cTRB  := ''
	Local cExp1 := 'EXPIRACAO EM'
	Local cExp2 := 'EXPIRA EM'
	
	cSQL := "SELECT R_E_C_N_O_ AS U4_RECNO,  "
	cSQL += "       U4_DESC, "
	cSQL += "       U4_DATA "
	cSQL += "FROM   "+RetSqlName("SU4")+" SU4 "
	cSQL += "WHERE  U4_FILIAL = "+ValToSql(xFilial("SU4"))+" "
	cSQL += "       AND SU4.D_E_L_E_T_ = ' ' "
	cSQL += "       AND U4_STATUS = '1'
	cSQL += "       AND U4_DTEXPIR = ' ' "
	cSQL += "ORDER  BY R_E_C_N_O_"

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	PLSQuery( cSQL, cTRB )

	While .NOT. (cTRB)->(EOF())
		// Se achar 'EXPIRACAO EM'
		If cExp1 $ (cTRB)->U4_DESC 
			nP := At( cExp1, (cTRB)->U4_DESC  )
			dData := Ctod( SubStr( (cTRB)->U4_DESC, nP+13, 8 ) )
		Endif
		
		// Se achar 'EXPIRA EM'
		If nP == 0 .And. Empty( dData )
			If cExp2 $ (cTRB)->U4_DESC 
				nP := At( cExp2, (cTRB)->U4_DESC  )
				dData := Ctod( SubStr( (cTRB)->U4_DESC, nP+10, 8 ) )
			Endif
		Endif
		
		// Se não achou 'EXPIRACAO EM' e 'EXPIRA EM'
		If nP == 0 .And. Empty( dData )
			nP := 1
			dData := (cTRB)->U4_DATA
		Endif
		
		// Gravar o dado.
		If nP > 0 .And. .NOT. Empty( dData )
			SU4->( dbGoto( (cTRB)->U4_RECNO ) )
			If SU4->( RecNo() ) == (cTRB)->U4_RECNO
				SU4->( RecLock( 'SU4', .F. ) )
				SU4->U4_DTEXPIR := dData
				SU4->( MsUnLock() )
			Endif
			nP := 0
			dData := Ctod(sPace(8))
		Endif
		(cTRB)->( dbSkip() )
	End
Return

/* Rotina para atualizar os campos U6_DTANTEND e U6_HRATEND. */
User Function Upd110Rec()
	If MsgYesNo('Confirma a execução da atualização do campo U6_DTATEND e U6_HRATEND baseados nos campos U6_DATA e U6_HRINI?','UPD110REC')
		MsgRun('Aguarde, efetuando update de registros...','UPD110REC',{|| Upd110Rec1() } )
	Endif
Return
Static Function Upd110Rec1()
	Local cSQL := ''
	Local nHandle := 0
	Local cArqLog := GetPathSemaforo() + 'upd110r1.log'

	If ! File( cArqLog )
	   nHandle := FCreate( cArqLog )
	   FClose( nHandle )
	   
		cSQL := "UPDATE "+RetSqlName("SU6")+" "
		cSQL += "SET    U6_DTATEND = U6_DATA, "
		cSQL += "       U6_HRATEND = U6_HRINI || ':00' "
		cSQL += "WHERE  U6_FILIAL = "+ValToSql( xFilial("SU6") )+"  "
		cSQL += "       AND U6_STATUS = '2' "
		cSQL += "       AND U6_DTATEND = ' '  "
		cSQL += "       AND U6_HRATEND = ' '  "
		cSQL += "       AND D_E_L_E_T_ = ' ' " 
		
		If TCSqlExec( cSQL ) < 0
			MsgStop('Ocorreu o seguinte erro: '+Chr(10)+Chr(10)+AllTrim(TcSqlError()))
		Endif
	Endif
Return

//------------------------------------------------------------------
// Rotina | UPD110()   | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina de update para criar as estruturas no dicionário
//        | de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function UPD110()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U110Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//------------------------------------------------------------------
// Rotina | U110Ini    | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function U110Ini()
	aSX3  := {}
	aHelp := {}

	AAdd(aSX3,{	'SU6',NIL,'U6_ATENDIM','C',8,0,;                                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Atendimento','Atendimento','Atendimento',;                                               //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Codigo do atendimento','Codigo do atendimento','Codigo do atendimento',;                 //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                    //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€€',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                   //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'SU6',NIL,'U6_DTATEND','D',8,0,;                                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'DT.Atend.','DT.Atend.','DT.Atend.',;                                                     //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Data do atendimento','Data do atendimento','Data do atendimento',;                       //Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;                                                                                      //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                   //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','','N','N'})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'SU6',NIL,'U6_HRATEND','C',8,0,;                                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'HR.Atend.','HR.Atend.','HR.Atend.',;                                                     //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Hora do atendimento','Hora do atendimento','Hora do atendimento',;                       //Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;                                                                                      //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€ ',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                   //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','','N','N'})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'SUD',NIL,'UD_LSTCONT','C',12,0,;                                             	         //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Lista Contat','Lista Contat','Lista Contat',;                                            //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Codigo da lista de contat','Codigo da lista de contat','Codigo da lista de contat',;     //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                                                                    //Picture
					'',;                                                                                      //Valid
					'€€€€€€€€€€€€€€€',;                                                                       //Usado
					'',;                                                                                      //Relacao
					'',0,'þA','','',;                                                                         //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;	                                                                                   //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'SUD',NIL,'UD_QUANT','N',12,2,;                                             	             //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Quantidade','Quantidade','Quantidade',;                                                  //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Quantidade','Quantidade','Quantidade',;                                                  //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@E 999,999,999.99',;                                                                     //Picture
					'',;                                                                                      //Valid
					X3_EMUSO_USADO,;                                                                          //Usado
					'',;                                                                                      //Relacao
					'',1,X3_USADO_RESERV,'','S',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'Positivo()',;                                                                            //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','U_A110Edit( ReadVar() )','','','',;                                                   //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld


	AAdd(aSX3,{	'SUD',NIL,'UD_VUNIT','N',12,2,;                                             	             //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Vl. Unitario','Vl. Unitario','Vl. Unitario',;                                            //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Valor unitario','Valor unitario','Valor unitario',;                                      //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@E 999,999,999.99',;                                                                     //Picture
					'',;                                                                                      //Valid
					X3_EMUSO_USADO,;                                                                          //Usado
					'',;                                                                                      //Relacao
					'',1,X3_USADO_RESERV,'','S',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'Positivo()',;                                                                            //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','U_A110Edit( ReadVar() )','','','',;                                                   //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	
	AAdd(aSX3,{	'SUD',NIL,'UD_TOTAL','N',12,2,;                                             	             //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Total','Total','Total',;                                                                 //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Valor total','Valor total','Valor total',;                                               //Desc. Port.,Desc.Esp.,Desc.Ing.
					'@E 999,999,999.99',;                                                                     //Picture
					'',;                                                                                      //Valid
					X3_EMUSO_USADO,;                                                                          //Usado
					'',;                                                                                      //Relacao
					'',1,X3_USADO_RESERV,'','S',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;                                                                                      //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld

	AAdd(aSX3,{	'SU4',NIL,'U4_DTEXPIR','D',8,0,;                                                          //Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'DT. Expira','DT. Expira','DT. Expira',;                                                  //Tit. Port.,Tit.Esp.,Tit.Ing.
					'Data que expira o certif.','Data que expira o certif.','Data que expira o certif.',;     //Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;                                                                                      //Picture
					'',;                                                                                      //Valid
					X3_EMUSO_USADO,;                                                                          //Usado
					'',;                                                                                      //Relacao
					'',1,X3_USADO_RESERV,'','S',;                                                             //F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                                                     //Propri,Browse,Visual,Context,Obrigat
					'',;                                                                                      //VldUser
					'','','',;                                                                                //Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                                                          //PictVar,When,Ini BRW,GRP SXG,Folder
					'N','','','',' ',' '})                                                                    //Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	
	
	//+-----------------------------------------------------------------------------+
	//| Nome: David Santos                                                          | 
	//| Data: 21/11/2016                                                            |
	//| Descricao: Criacao de campos para melhorar a agilidade do atendimento.      |
	//+-----------------------------------------------------------------------------+
	AAdd(aSX3,{	'SUC',NIL,'UC_XPROXAC','C',1,0,;																   //-- Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Prox. Acao','Prox. Acao','Prox. Acao',;														   //-- Tit. Port.,Tit.Esp.,Tit.Ing.
					'Proxima Acao','Proxima Acao','Proxima Acao',;												   //-- Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;																								   //-- Picture
					'Pertence("123")',;																				   //-- Valid
					'CCCCCCCCCCCCCCa',;																				   //-- Usado
					'',;																								   //-- Relacao
					'',1,'þA','','',;																					   //-- F3,Nivel,Reserv,Check,Trigger
					'','N','','',' ',;																				   //-- Propri,Browse,Visual,Context,Obrigat
					'',;																								   //-- VldUser
					'1=Proposta;2=Faturamento;3=Oportunidade',;													   //-- Box Portugues
					'1=Proposta;2=Faturamento;3=Oportunidade',;													   //-- Box Espanhol
					'1=Proposta;2=Faturamento;3=Oportunidade',;													   //-- Box Ingles
					'','','','','',;																					   //-- PictVar,When,Ini BRW,GRP SXG,Folder
					'S','','','N','N',' '})																			   //-- Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	
	AAdd(aSX3,{	'SUC',NIL,'UC_XCARGO','C',6,0,;																	   //-- Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Cargo','Cargo','Cargo',;																		   //-- Tit. Port.,Tit.Esp.,Tit.Ing.
					'Cargo','Cargo','Cargo',;																		   //-- Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;																								   //-- Picture
					'',;																								   //-- Valid
					'CCCCCCCCCCCCCCa',;																				   //-- Usado
					'',;																								   //-- Relacao
					'SUM',1,'þA','','',;																				   //-- F3,Nivel,Reserv,Check,Trigger
					'','N','','',' ',;																				   //-- Propri,Browse,Visual,Context,Obrigat
					'',;																								   //-- VldUser
					'',;																								   //-- Box Portugues
					'',;																								   //-- Box Espanhol
					'',;																								   //-- Box Ingles
					'','','','','',;																					   //-- PictVar,When,Ini BRW,GRP SXG,Folder
					'S','','','N','N',' '})																			   //-- Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	
	AAdd(aSX3,{	'SUC',NIL,'UC_XCONCOR','C',100,0,;																   //-- Alias,Ordem,Campo,Tipo,Tamanho,Decimais
					'Inf. Concorr','Inf. Concorr','Inf. Concorr',;												   //-- Tit. Port.,Tit.Esp.,Tit.Ing.
					'Info. da Concorrencia','Info. da Concorrencia','Info. da Concorrencia',;					   //-- Desc. Port.,Desc.Esp.,Desc.Ing.
					'',;																								   //-- Picture
					'',;																								   //-- Valid
					'CCCCCCCCCCCCCCa',;																				   //-- Usado
					'',;																								   //-- Relacao
					'',1,'þA','','',;																					   //-- F3,Nivel,Reserv,Check,Trigger
					'','N','','',' ',;																				   //-- Propri,Browse,Visual,Context,Obrigat
					'',;																								   //-- VldUser
					'',;																								   //-- Box Portugues
					'',;																								   //-- Box Espanhol
					'',;																								   //-- Box Ingles
					'','','','','',;																					   //-- PictVar,When,Ini BRW,GRP SXG,Folder
					'S','','','N','N',' '})																			   //-- Pyme,CondSQL,ChkSQL,IdxSrv,Ortogra,IdxFld
	
	
	aHelp := {}
	aAdd(aHelp,{'U6_ATENDIM', 'Codigo do atendimento que esta agenda do operador gerou.'})
	aAdd(aHelp,{'U6_DTATEND', 'Data do atendimento, ou seja, quando foi atendido a agenda.'})	
	aAdd(aHelp,{'U6_HRATEND', 'Hora do atendimento, ou seja, quando foi atendido a agenda.'})
	aAdd(aHelp,{'UD_LSTCONT', 'Codigo da lista de contato, ou seja, código e sequencia da lista de contato (agenda do operador).'})	
	aAdd(aHelp,{'UD_QUANT'  , 'Quantidade do produto em questão.'})
	aAdd(aHelp,{'UD_VUNIT'  , 'Valor unitário do produto em questão.'})
	aAdd(aHelp,{'UD_TOTAL'  , 'Total do produto em questão.'})
	aAdd(aHelp,{'U4_DTEXPIR', 'Data que expira a renovação do certificado.'})
	aAdd(aHelp,{'UC_XPROXAC', 'Proxima acao que sera realizada apos o atendimento.'})
	aAdd(aHelp,{'UC_XCARGO' , 'Codigo do cargo.'})
	aAdd(aHelp,{'UC_XCONCOR', 'Informacoes da concorrencia.'})
	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A110Clas		| Autor | Renato Ruy   	| Data | 24.05.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para inserir um atendimento de televendas a partir da 
//        | agenda.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Clas( oGride ) 

	Local oDlg
	Local oPnl1
	Local oPnl2
	Local oEnch
	Local oScroll
	Local oSplitter
	Local oFntBox
	Local oTLbx
	
	Local aPos 	      := {0,0,400,600}
	Local aCpoEnch      := {}
	Local aAlterEnch    := {}
	Local aCpoCfg       := {}
	Local aField        := {}
	Local aSay          := {}
	Local aCpoLst       := {}
	Local aDados        := {}
	Local aSize         := {}
	
	Local nX            := 0
	Local nOpc          := 0
	Local nI            := 0
	Local nP            := 0
	Local nList         := 0
	Local nLargPanel    := 0
	
	Local cTitulo       := ''
	Local cF3           := ''
	Local cValid        := ''
	Local cPicture      := ''
	Local cWhen         := ''
	Local cDado         := ''
	Local cMV_ENCHOLD   := ''
	
	Local lMemoria      := .F.
	Local lObrigat      := .F.
	Local lPutMvEnchOld := .F.
	
	Local nU4_DESC      := 0
		
	Private aRetEncer   := {}
	Private nLin        := 0
	Private nU4_RECNO   := 0
	Private nU6_RECNO   := 0
	Private cU6_CODOPER := ''
	Private cUC_INICIO  := ''
	Private cUC_CODIGO  := ''
	Private aUD_RECNO   := {}
	
	//--------------------------------------------------------
	// Verificar se o usuário está cadastrado como supervisor.
	//--------------------------------------------------------
	cU6_TIPOPER := SU7->(Posicione('SU7',4,xFilial('SU7')+__cUserID,'U7_TIPO'))
	
	If cU6_TIPOPER != "2"
		MsgInfo('O usuario deve ser supervisor para utilizar a rotina!', cCadastro )
		Return
	EndIf
	
	//---------------------------
	// Montar dados para o TList.
	//---------------------------
	nLin := Iif(oGride:nAt==0,1,oGride:nAt)
	
	nU4_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U4_RECNO'})
	nU5_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U5_RECNO'})
	nU6_RECNO := AScan(oGride:aHeader,{|p| p[2]=='U6_RECNO'})
	
	nU4_RECNO := oGride:aCOLS[nLin,nU4_RECNO]
	nU5_RECNO := oGride:aCOLS[nLin,nU5_RECNO]
	nU6_RECNO := oGride:aCOLS[nLin,nU6_RECNO]
	
	SU4->(dbGoTo(nU4_RECNO))
	SU5->(dbGoTo(nU5_RECNO))
	SU6->(dbGoTo(nU6_RECNO))

	AAdd( aCpoLst ,{'U5_CODCONT' ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_CONTAT'  ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_DDD'     ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FONE'    ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_CELULAR' ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FCOM1'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_FCOM2'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'U5_EMAIL'   ,''             ,'SU5'} )
	AAdd( aCpoLst ,{'GD_LEGENDA' ,''             ,''   } )
	AAdd( aCpoLst ,{'U4_DATA'    ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U4_HORA1'   ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U6_ENTIDA'  ,'Sigla Entid.' ,'SU6'} )
	AAdd( aCpoLst ,{'U6_DENTIDA' ,'Descr.sigla ' ,'SU6'} )
	AAdd( aCpoLst ,{'U4_DESC'    ,''             ,'SU4'} )
	AAdd( aCpoLst ,{'U4_LISTA'   ,''             ,'SU4'} )
	
	SX3->(dbSetOrder(2))
	For nI := 1 To Len(aCpoLst)
		If Empty(aCpoLst[nI,2])
			If SX3->(dbSeek(aCpoLst[nI,1]))
				cTitulo := SX3->X3_TITULO
			Else
				cTitulo := 'Legenda     '
			Endif
		Else
			cTitulo := aCpoLst[nI,2]
		Endif
		nP := AScan(oGride:aHeader,{|p| p[2]==aCpoLst[nI,1]})
		If nP > 0
			cDado := oGride:aCOLS[nLin,nP]
		Else
			cDado := &(aCpoLst[nI,3]+'->'+aCpoLst[nI,1])
		Endif
		If Valtype(cDado)=='N'
			cDado := LTrim(TransForm(cDado,'@E 999,999,999.99'))
		Elseif ValType(cDado)=='D'
			cDado := Dtoc(cDado)
		Endif
		AAdd(aDados,cTitulo+': '+cDado)
	Next nI
	
	//Estrutura do vetor
	//[1] - Campo
	//[2] - Título
	//[3] - F3
	//[4] - Valid
	//[5] - Obrigatório => .T. sim, .F. considerar o que está no SX3.
	//[6] - Picture
	//[7] - When

	AAdd(aCpoCfg,{'UD_ASSUNTO','Cód.do assunto'   	,'T1_110','Vazio().Or.(ExistCpo("SX5","T1"+M->UD_ASSUNTO).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCASS','Descr.do assunto' 	,'','',.F.,'',''})
	AAdd(aCpoCfg,{'UD_OCORREN','Cód.da ocorrên.'  	,'SU9110','Vazio().Or.(ExistCpo("SU9",M->UD_ASSUNTO+M->UD_OCORREN).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCOCO','Descr.ocorrên.'		,'','',.F.,'',''})
	AAdd(aCpoCfg,{'UD_SOLUCAO','Código da ação'   	,'SUR110','Vazio().Or.(ExistCpo("SUQ",M->UD_SOLUCAO).And.U_A110Gat01())',.T.,'@!',''})
	AAdd(aCpoCfg,{'UD_DESCSOL','Descr.da ação'    	,'','',.F.,'',''})
	AAdd(aCpoCfg,{'UC_CODENCE','Encerramento'			,'','',.F.,'',''})
	
	// cAlias - Prefixo da tabela.
	// lInicialização de operação -> .T. Inclusão.
	// lDicionário - Características baseadas no SX3.
	// lInicialização do dicionário será executada?
	RegToMemory( "SUC", .T., .T., .F. )
	RegToMemory( "SUD", .T., .T., .F. )
	
	SX3->(dbSetOrder(2))
	For nX := 1 To Len(aCpoCfg)
		If SX3->(dbSeek(aCpoCfg[nX,1]))
			cTitulo  := Iif(Empty(aCpoCfg[nX,2]),SX3->X3_TITULO,aCpoCfg[nX,2])
			cF3      := Iif(Empty(aCpoCfg[nX,3]),SX3->X3_F3    ,aCpoCfg[nX,3])
			cValid   := Iif(Empty(aCpoCfg[nX,4]),SX3->X3_VALID ,aCpoCfg[nX,4])
			lObrigat := Iif(aCpoCfg[nX,5],aCpoCfg[nX,5],X3Obrigat(SX3->X3_CAMPO))
			cPicture := Iif(Empty(aCpoCfg[nX,6]),SX3->X3_PICTURE,aCpoCfg[nX,6])
			cWhen    := Iif(Empty(aCpoCfg[nX,7]),SX3->X3_WHEN,aCpoCfg[nX,7])
			
	   	AAdd( aField, {	cTitulo,;
							SX3->X3_CAMPO,;
							SX3->X3_TIPO,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							cPicture,;
							&("{||" + AllTrim(cValid)+ "}"),;
							lObrigat,;
							SX3->X3_NIVEL,;
							SX3->X3_RELACAO,;
							cF3,;
							&("{||" + RTrim(cWhen) + "}"),;
							SX3->X3_VISUAL=="V",;
							.F.,; 
							SX3->X3_CBOX,;
							VAL(SX3->X3_FOLDER),;
							.F.,;
							""} )
		Endif
	Next nX
	
	//Me posiciono na tabela para trazer a informação atual.
	SUC->(DbSetOrder(1))
	SUC->(DbSeek(xFilial("SUC")+SubStr(SU6->U6_ATENDIM,1,6)))
	
	SUD->(DbSetOrder(1))
	SUD->(DbSeek(xFilial("SUD")+SubStr(SU6->U6_ATENDIM,1,6)))
		
	//Atualiza o conteudo com a informacao em memoria.
	M->UD_ASSUNTO := SUD->UD_ASSUNTO
	M->UD_DESCASS := Posicione("SX5",1,xFilial("SX5")+"T1"+SUD->UD_ASSUNTO,"X5_DESCRI")
	M->UD_OCORREN := SUD->UD_OCORREN
	M->UD_DESCOCO := Posicione("SU9",2,xFilial("SU9")+SUD->UD_OCORREN,"U9_DESC")
	M->UD_SOLUCAO := SUD->UD_SOLUCAO
	M->UD_DESCSOL := Posicione("SUQ",1,xFilial("SUQ")+SUD->UD_SOLUCAO,"UQ_DESC")
	M->UC_CODENCE := SUC->UC_CODENCE
		
	//------------------------------------------------------------------------------------------------------------
	// Parâmetro MV_ENCHOLD controla a visualização da Enchoice ou MsMGet no padrão das versões anteriores ao P11.
	// Modificar o conteúdo para o padrão antigo e logo que executar a classe reestabelecer o conteúdo original.
	//------------------------------------------------------------------------------------------------------------
	cMV_ENCHOLD := GetMv('MV_ENCHOLD',,'1')
	If cMV_ENCHOLD<>'1'
		cMV_ENCHOLD := '1'
		lPutMvEnchOld := .T.
		PutMv('MV_ENCHOLD','1')
	Endif	
	If cMV_ENCHOLD=='1'
		nLargPanel := 170
		aSize := {0,0,0,0,1000,400,0}
	Else
		nLargPanel := 40
		aSize := MsAdvSize( .T. )
	Endif
	
	DEFINE MSDIALOG oDlg TITLE "Tabulação de Atendimento" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL 
		oDlg:lMaximized := (GetMv('MV_110DIM')=='1')
		
		oSplitter := TSplitter():New(1,1,oDlg,260,184,2)
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl1:= TPanel():New(2,2,,oSplitter,,,,,RGB(67,70,87),nLargPanel,60)
		oPnl1:Align := CONTROL_ALIGN_LEFT
		
		oPnl2:= TPanel():New(2,2,,oSplitter,,,,,RGB(67,70,87),60,26)
		oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
	
	   oScroll := TScrollBox():New(oPnl1,1,1,100,100,.T.,.F.,.T.)
	   oScroll:Align := CONTROL_ALIGN_ALLCLIENT

		oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oScroll,,,,.T.,,,oFntBox)
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx:SetArray(aDados)

		oEnch := MsMGet():New(	"SUC",;
									SUC->(RecNo()),;
									3,;
									/*aCRA*/,;
									/*cLetras*/,;
									/*cTexto*/,;
									aCpoCfg,;
									aPos,;
									/*aAlterEnch*/,;
									/*nModelo*/,;
									/*nColMens*/,;
									/*cMensagem*/,;
									/*cTudoOk*/,;
									oPnl2,;
									/*lF3*/,;
									lMemoria,;
									/*lColumn*/,;
		        					/*caTela*/,;
		        					/*lNoFolder*/,;
		        					/*lProperty*/,;
		        					aField,;
		        					/*aFolder*/,;
		        					/*lCreate*/,;          
		        					/*lNoMDIStretch*/,;
		        					/*cTela*/)   
		oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		
		//-----------------------------------
		// Reestabelecer o conteúdo original.
		//-----------------------------------
			PutMv('MV_ENCHOLD','2')
		
		//-------------------------------------------------------------------------------------------------
		// Esta variável está sendo atribuída aqui para calcular o tempo do usuário e não do processamento.
		//-------------------------------------------------------------------------------------------------
		cUC_INICIO := Time()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| Iif(A110ClaOk(),(nOpc:=1,oDlg:End()),NIL)}, {|| oDlg:End() } )
	
	If nOpc == 1
		While !SUD->(EOF()) .And. SUD->UD_CODIGO == SubStr(SU6->U6_ATENDIM,1,6)
			RecLock("SUD",.F.)
				SUD->UD_ASSUNTO := M->UD_ASSUNTO
				SUD->UD_OCORREN := M->UD_OCORREN
				SUD->UD_SOLUCAO := M->UD_SOLUCAO
			SUD->(MsUnlock()) 
			SUD->(DbSkip())
		Enddo
        
		RecLock("SUC",.F.)
			SUC->UC_CODENCE := M->UC_CODENCE
		SUC->(MsUnlock())
	Endif

Return 

//-----------------------------------------------------------------------
// Rotina | A110TudOK    | Autor | Robson Gonçalves   | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se os campos de preenchimento obrigatório
//        | foram preenchidos, validar os campos necessários e se for
//        | encerramento 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110ClaOk()
	Local lRet := .F.
	
	If !Empty(M->UD_ASSUNTO) .And. !Empty(M->UD_OCORREN) .And. !Empty(M->UD_SOLUCAO) .And. !Empty(M->UC_CODENCE)
		lRet := .T.
	Else
		lRet := .F.
		MsgInfo('Favor preencha todos os dados para prosseguir com a alteração.',cCadastro)
	Endif
	
Return(lRet)
//-----------------------------------------------------------------------
// Rotina | CSFA110V    | Autor | Renato Ruy  | Data | 28.06.2016
//-----------------------------------------------------------------------
// Descr. | Aviso de agendas vencidas para o operador.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFA110V()

Local nPosDat := AScan(oGride1:aHeader,{|p| p[2]=="U4_DTEXPIR"})
Local nPosTip := AScan(oGride1:aHeader,{|p| p[2]=="U6_ENTIDA"}) 
Local nI      := 0
Local nQtd    := 0
Local cMVDIAS := dDataBase - GetMv("MV_XDIAAGE")
Local cMVTIPO := GetMv("MV_XAVIAGE")

For nI := 1 to Len(oGride1:aCols)

	If oGride1:aCols[nI][nPosDat] < cMVDIAS .And. AllTrim(oGride1:aCols[nI][nPosTip]) $ cMVTIPO
		nQtd += 1
	EndIf
	
Next

If nQtd > 0
	MsgInfo("Existe "+AllTrim(Str(nQtd))+" agendas em atraso, para os tipos: "+FormatIn(cMVTIPO,"|"),"Agenda Certisign")
EndIf

Return
//-----------------------------------------------------------------------
// Rotina | CSFA110I    | Autor | Renato Ruy  | Data | 20.07.2016
//-----------------------------------------------------------------------
// Descr. | Rastrear oportunidade e televendas vinculado no atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFA110I(oGride)

Local nLin    := oGride:nAt
Local cCodAte := SubStr(oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == 'U6_ATENDIM' } ) ],1,6)// Capturar o numero do atendimento (SUC)
Local cCodOpo := ""
Local cAviso  := ""
Local cNumber := 0

If Empty(cCodAte)
	cAviso := 'Não houve atedimentos para esta oportunidade!' 
Else
	SUC->(dbSetOrder(1))
	SUC->(dbSeek(xFilial('SUC')+cCodAte)) 
	
	//'SUA->UA_OPORTUN','SUC->UC_OPORTUN' - Validar os campos para verificar se tem oportunidade.
	SUA->( dbSetOrder( 1 ) )
	If SUA->( dbSeek( xFilial( 'SUA' ) + Left(SUC->UC_TELEVEN,6) ) ) .And. !Empty(SUC->UC_TELEVEN)
		
		cCodOpo:= Iif(Empty(SUA->UA_OPORTUN),SUC->UC_OPORTUN,SUA->UA_OPORTUN)
		If !Empty(cCodOpo)
			cAviso += 'Oportunidade: ' + cCodOpo  + CRLF
		EndIf
		
		If Empty(SUA->UA_XORIG) .Or. cCodAte <> SUA->UA_XORIG
			cAviso += 'Televendas:    ' + SUA->UA_NUM  + CRLF
		Endif
		
		//Se posiciona no novo vinculo.
		SUA->( dbSetOrder( 12 ) )
		If SUA->( dbSeek( xFilial( 'SUA' ) + cCodAte ))
			
			While !SUA->(EOF()) .And. SUA->UA_XORIG == cCodAte
				
				cNumber ++
			
				cAviso += 'Televendas'+AllTrim(Str(cNumber))+':   ' + SUA->UA_NUM  + CRLF
				
			    SUA->(Dbskip())
			Enddo
		Endif
		

	Elseif !Empty(cCodAte) .And. !Empty(SUC->UC_OPORTUN) 
		cAviso += 'Oportunidade: ' + SUC->UC_OPORTUN + CRLF
	Else
		cAviso += 'Não existe televendas ou oportunidade vinculada ao atendimento!'
	Endif
EndIf
//Copia conteúdo para área de transferência
CopytoClipboard(cAviso)

MsgInfo(cAviso,'Agenda Certisign')
	
Return

//-----------------------------------------------------------------------
// Rotina | CSFA110C    | Autor | Renato Ruy  | Data | 28.06.2016
//-----------------------------------------------------------------------
// Descr. | Chama base de conhecimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFA110C(oGride)

Local cChave	    := ""
Local cU4_CODLIG  := ""
Local cU6_ATENDIM := ""
Private aRotina   := {{"Conhecimento" ,"MsDocument",0,10}}

cU4_CODLIG  := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U4_CODLIG'	  } ) ]
cU6_ATENDIM := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[2] == 'U6_ATENDIM'	  } ) ]
cChave := SubStr(Iif(Empty(cU4_CODLIG),cU6_ATENDIM,cU4_CODLIG),1,6)

SUC->( dbSetOrder( 1 ) )
SUC->( MsSeek( xFilial( 'SUC' ) + cChave ) )

MsDocument('SUC', SUC->(RECNO()), 1 ) 

Return

//-----------------------------------------------------------------------
// Rotina | CSFA110R    | Autor | Renato Ruy  | Data | 12.08.2016
//-----------------------------------------------------------------------
// Descr. | Rastrear atendente da ultima agenda
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA110R()

Local aPergs    := {}
Local aRet      := {}
Local cLigacao  := ""
Local cOperador := ""
Local cOperacao := ""
Local cProximo  := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe os dados da ultima ligacao seja Prospect ou Cliente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SUA")
DbSetOrder(7)   //UA_FILIAL+UA_CLIENTE+UA_LOJA+STR(UA_DIASDAT,8,0)+STR(UA_HORADAT,8,0)
If DbSeek(xFilial("SUA") + SA1->A1_COD + SA1->A1_LOJA)
	
	cLigacao := DTOC(CTOD("01/01/45")-UA_DIASDAT)+" - "+Substr(SUA->UA_INICIO,1,5)
	cOperador:= Posicione("SU7",1,xFilial("SU7") + SUA->UA_OPERADO,"U7_NOME")
	
	If !Empty(SUA->UA_PROXLIG)
		cProximo:= DTOC(SUA->UA_PROXLIG) + " - " + SUA->UA_HRPEND + " - " + cOperador
	Endif
	
	cOperacao:= Tk273Status(SUA->UA_STATUS)
	
	MsgInfo("Última ligação: "+cLigacao+CRLF+;
			"Operador: "+cOperador+CRLF+;
			"Próximo ligação: "+cProximo+CRLF)
Else
	Alert("Não encontramos registro de agenda para este cliente!","Agenda Certisign")
Endif

Return



Static Function CSFA110HOR(cHora, cMinSub)
	
	Local cRet      := ""
	Local nSubHoras := 0
	
	nSubHoras := SubHoras(cHora, cMinSub)
	
	If Len(cValToChar(nSubHoras)) == 1
		cRet := "0" + cValToChar(nSubHoras) + ":00"
	ElseIf Len(cValToChar(nSubHoras)) == 2
		cRet := cValToChar(nSubHoras) + ":00"
	Else
		If nSubHoras < 10
			cRet := StrTran("0" + cValToChar(nSubHoras),".",":")
			If Len(cRet) <= 4
				cRet += "0"
			EndIf
		Else
			cRet := StrTran(cValToChar(nSubHoras),".",":")
			If Len(cRet) <= 4
				cRet += "0"
			EndIf
		EndIf
	EndIF
Return( cRet )

//-----------------------------------------------------------------------
// Rotina | A110Param    | Autor | Rafael Beghini  | Data | 18.12.2017
//-----------------------------------------------------------------------
// Descr. | Cria o parâmetro para controle de acesso por Operador
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A110Param()
	Local cMvAgOp	:= 'AGOP' + cU7_COD
	Local cMV_110TPBL := 'MV_110TPBL'
	Local lRet	:= .T.
	
	If .NOT. SX6->( ExisteSX6( cMvAgOp ) )
		CriarSX6( cMvAgOp, 'C', 'CONTROLE DE ACESSO A AGENDA POR OPERADOR. CSFA110.prw', '' )
	Endif
	
	If .NOT. SX6->( ExisteSX6( cMV_110TPBL ) )
		CriarSX6( cMV_110TPBL, 'L', 'HABILITA O CONTROLE DE ACESSO A AGENDA DO OPERADOR POR SEMAFORO. CSFA110.prw', '.F.' )
	Endif
	lAcessoLck := GetMv( cMV_110TPBL )	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A110SX6    | Autor | Rafael Beghini    | Data | 01.03.2018
//-----------------------------------------------------------------------
// Descr. | Rotina chamada via menu para alteração dos parâmetros 
//        | relacionados á Agenda
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A110SX6()
	Local cU7_TIPO	:= ''
	Local lRet		:= .F.
	
	Private cCadastro := '[A110SX6] - Parâmetros Agenda'
	
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserID ) )
		lRet       := .T.
		cU7_TIPO   := SU7->U7_TIPO
	Else
		MsgInfo( 'Usuário não está cadastrado como operador, por favor, verifique.', cCadastro )
		Return
	Endif
	
	IF lRet
		A110ChgSX6()
	EndIF
Return

/*Static Function UnlockAgnd(e)

PutMv(__cMvAgOp,' ')
ErrorBlock(__bOldBlock)
BREAK

Return*/