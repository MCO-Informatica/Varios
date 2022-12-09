//-----------------------------------------------------------------------
// Rotina | CSFA260    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de cadastro de solicitação de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#DEFINE cTP_DOC '#3' // Tipo de documento em SCR para da solicitação de despesa.
#DEFINE cFONT   '<b><font size="4" color="blue"><b>'
#DEFINE cFONT_V '<b><font size="4" color="red"><b>'
#DEFINE cNOFONT '</b></font></b> '

User Function CSFA260()
	Private lMV_260New := A260New()
	Private cCadastro := 'Solicitação de Despesa'
	Private aRotina := {}
	
	
	AAdd( aRotina, {"Pesquisar"        ,"AxPesqui"   ,0, 1 } )
	AAdd( aRotina, {"Visualizar"       ,"AxVisual"   ,0, 2 } )
	AAdd( aRotina, {"Incluir"          ,"U_A260Inc"  ,0, 3 } )
	AAdd( aRotina, {"Alterar"          ,"U_A260Alt"  ,0, 4 } )
	AAdd( aRotina, {"Excluir"          ,"U_A260Exc"  ,0, 5 } )
	
	If lMV_260New
		AAdd( aRotina, {"Solicitar Aprov"  ,"U_A260SApr" ,0, 6 } )
	Else
		AAdd( aRotina, {"Aprovar"          ,"U_A260Apr"  ,0, 6 } )
		AAdd( aRotina, {"Rejeitar"         ,"U_A260Rej"  ,0, 6 } )
	Endif
	
	AAdd( aRotina, {"Complementar"     ,"U_A260Compl",0, 6 } )
	
	If lMV_260New
		AAdd( aRotina, {"Cancelar"         ,"U_A260CAR" ,0 ,6 } ) // [C]ancelar [A]provação ou [R]ejeição
	Else	
		AAdd( aRotina, {"Cancelar"         ,"U_A260Canc" ,0 ,6 } )
	Endif
	
	AAdd( aRotina, {"Anexar Documentos","MsDocument" ,0 ,4 } )
	AAdd( aRotina, {"Legenda"          ,"U_A260Leg"  ,0, 6 } )
	
	dbSelectArea('PAD')
	dbSetOrder(1)
	
	MBrowse(,,,,'PAD',,,,,,U_A260Leg(.T.))
Return

//-----------------------------------------------------------------------
// Rotina | A260Inc    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de inclusão de solicitação de despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Inc( cAlias, cRecNo, nOpc )
	If AxInclui(cAlias, cRecNo, nOpc, , , , 'U_A260TOkInc()')==1
		PAD->(RecLock('PAD',.F.))
		PAD->PAD_STATUS := '0'
		PAD->(MsUnLock())
		MsgInfo('Operação de incluir realizada com sucesso.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260TOkInc | Autor | Robson Gonçalves     | Data | 18.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar a gravação da solicitação sem valor de 
//        | adiantamento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260TOkInc()
	Local lRet := .T.
	If M->PAD_VLRADI==0
		If .NOT. MsgYesNo('O registro está com o valor de adiantamento zerado, prosseguir com a confirmação?',cCadastro)
			lRet := .F.
		Endif
	Endif
	If lRet
		If Empty( M->PAD_ITCTB )
			MsgAlert(cFONT+'Por favor, preencher o campo CENTRO DE RESULTADO.'+cNOFONT,cCadastro)
			lRet := .F.
		Endif
	Endif
	If lRet
		If Empty( M->PAD_CLVL )
			MsgAlert(cFONT+'Por favor, preencher o campo PROJETOS.'+cNOFONT,cCadastro)
			lRet := .F.
		Endif
	Endif
	If lRet
		lRet := A260IsForn( M->PAD_SOLICI )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A260Alt    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de alteração da solicitação de despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Alt( cAlias, cRecNo, nOpc )
	Local nI := 0
	Local aAlter := {}
	Local cCpos := ''
	Local cPAD_STATUS := ''
	If PAD->PAD_STATUS == '0'
		AxAltera(cAlias, cRecNo, nOpc, , , , , 'U_A260TOkInc()')
		MsgInfo('Operação de alterar realizada com sucesso.',cCadastro)
	Else
		If PAD->PAD_STATUS $ '1|3'
			If PAD->PAD_COMPL == '0'
				cPAD_STATUS := Iif(PAD->PAD_STATUS=='1','1=Aprovado','3=Despesas digitadas')
				aAlter := { 'PAD_UF', 'PAD_MOT', ;
				            'PAD_VLPAAE', 'PAD_VLAPAE', 'PAD_VLHOSP', 'PAD_PINIRE', 'PAD_PFIMRE','PAD_VLALVE',;
				            'PAD_BANCO', 'PAD_AGENCI', 'PAD_DVAGEN', 'PAD_NUMCTA', 'PAD_DVCTA' }
				For nI := 1 To Len( aAlter )
					cCpos += RTrim( NGSEEKDIC( 'SX3', aALter[ nI ], 2, 'X3_TITULO') ) + ' / '
				Next nI
				cCpos := SubStr( cCpos, 1, Len( cCpos )-3 )
				MsgInfo( 'O status da Solicitação da Despesas é ['+cPAD_STATUS+'] por este motivo somente será possível alterar os campos ['+cCpos+'].',cCadastro)
				AxAltera(cAlias, cRecNo, nOpc, , aAlter, , , 'U_A260TOkInc()')
			Else
				MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
			Endif
		Else
			MsgAlert('Solicitação de despesa não pode sofrer manutenção, pois já está em outro status.',cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260Exc    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de exclusão de solicitação de despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Exc( cAlias, cRecNo, nOpc )
	If PAD->PAD_STATUS == '0'
		AxDeleta(cAlias, cRecNo, nOpc)
		MsgInfo('Operação de exclusão realizada com sucesso.',cCadastro)
	Else
		MsgAlert('Solicitação de despesa não pode sofrer manutenção, pois já está em outro status.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260Apr    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de aprovação da solicitação da despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Apr( cAlias, nRecNo, nOpc )
	Local aAcho := {}	
	If PAD->PAD_STATUS == '0'
		SX3->(dbSetOrder(1))
		SX3->(dbSeek('PAD'))
		While SX3->(.NOT. EOF()) .And. SX3->X3_CAMPO == 'PAD'
			If X3USO(SX3->X3_USADO)
				AAdd(aAcho,SX3->X3_CAMPO)
			Endif
			SX3->(dbSkip())
		End
		If AxAltera( cAlias, nRecNo, nOpc, aAcho, {}, , , 'U_A260TOkApr()') == 1
			PAD->(RecLock('PAD',.F.))
			PAD->PAD_STATUS := '1'
			PAD->PAD_USUAPR := RetCodUsr()
			PAD->PAD_DTAPR  := MsDate()
			PAD->(MsUnLock())
			MsgInfo('Operação de aprovação realizado com sucesso.',cCadastro)
		Endif
	Else
		MsgAlert('Solicitação de despesa não pode ser aprovada, pois já está em outro status.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260TOkApr | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar a aprovação da solicitação da despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260TOkApr()
	Local lRet := .F.
	If U_A260TOkInc()
		If MsgYesNo('Confirma a aprovação da solicitação de despesa?',cCadastro)
      	lRet := .T.
		Endif
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A260Rej    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de rejeição da solicitação da despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Rej( cAlias, nRecNo, nOpc )
	Local aAcho := {}	
	Private cPAD_MOTREJ := ''
	If PAD->PAD_STATUS == '0'
		SX3->(dbSetOrder(1))
		SX3->(dbSeek('PAD'))
		While SX3->(.NOT. EOF()) .And. SX3->X3_CAMPO == 'PAD'
			If X3USO(SX3->X3_USADO)
				AAdd(aAcho,SX3->X3_CAMPO)
			Endif
			SX3->(dbSkip())
		End
		If AxAltera( cAlias, nRecNo, nOpc, aAcho, {}, , , 'U_A260TOkRej()') == 1
			PAD->(RecLock('PAD',.F.))
			PAD->PAD_STATUS := '2'
			PAD->PAD_MOTREJ := cPAD_MOTREJ
			PAD->PAD_USUREJ := RetCodUsr()
			PAD->PAD_DTREJ  := MsDate()
			PAD->(MsUnLock())
			MsgInfo('Operação de rejeição realizado com sucesso.',cCadastro)
		Endif
	Else
		MsgAlert('Solicitação de despesa não pode ser rejeitada, pois já está em outro status.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260TOkRej | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar a rejeição da despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260TOkRej()
	Local lRet := .F.
	Local aPar := {}
	Local aRet := {}
	If MsgYesNo('Confirma a rejeição da solicitação de despesa?',cCadastro)
		AAdd(aPar,{11,"Motivo da rejeição","",".T.",".T.",.T.})
		If ParamBox(aPar,"Registrar motivo da rejeição",@aRet,,,,,,,,.F.,.F.)
			lRet := .T.
			cPAD_MOTREJ := aRet[1]
		Else
			MsgAlert('A rejeição não foi efetivada para esta solicitação de despesas.',cCadastro)
		Endif
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A260Leg    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar as legendas das despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Leg( lBrowse )
	Local aLeg := {}
	Local aLegenda := NIL
	If ValType(lBrowse)=='L' .And. lBrowse
		aLegenda := {}
		AAdd( aLegenda, { 'PAD_STATUS=="0"','BR_BRANCO'  } ) //0=Solicitado
		AAdd( aLegenda, { 'PAD_STATUS=="1"','BR_VERDE'   } ) //1=Aprovado
		AAdd( aLegenda, { 'PAD_STATUS=="2"','BR_PRETO'   } ) //2=Rejeitado
		AAdd( aLegenda, { 'PAD_STATUS=="3"','BR_AMARELO' } ) //3=Despesas digitadas
		AAdd( aLegenda, { 'PAD_STATUS=="4"','BR_AZUL'    } ) //4=Despesas aprovadas
		AAdd( aLegenda, { 'PAD_STATUS=="5"','BR_PINK'    } ) //5=WF de aprovação enviado
	Else
		AAdd( aLeg, {'BR_BRANCO' ,'0=Solicitado'         } )
		AAdd( aLeg, {'BR_VERDE'  ,'1=Solic. Aprovada'    } )
		AAdd( aLeg, {'BR_PRETO'  ,'2=Solic. Rejeitada'   } )
		AAdd( aLeg, {'BR_AMARELO','3=Despesas digitadas' } )
		AAdd( aLeg, {'BR_AZUL'   ,'4=Despesas aprovadas' } )
		AAdd( aLeg, {'BR_PINK'   ,'5=WF de aprovação enviado' } )
		BrwLegenda(cCadastro,'Status da solicitação/despesas',aLeg)	
	Endif
Return(aLegenda)

//-----------------------------------------------------------------------
// Rotina | A260Compl  | Autor | Robson Gonçalves     | Data | 08.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para complementar a solicitação de despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Compl( cAlias, nRecNo, nOpc )
	Local aAcho := {}
	Local aCpos := {}
	Local aArea := {}
	Local cCpos := 'PAD_PERDE|PAD_PERATE|PAD_MOTIVO|PAD_VLRADI|PAD_OUTMOE|PAD_MOEDA'
	Local cPAD_NUMERO := PAD->PAD_NUMERO
	Local nComplemento := 0
	Private cPAD_COMPL := ''
	If PAD->PAD_STATUS == '1'
		If PAD->PAD_COMPL == '0'
			MsgInfo('Ao complementar uma solicitação de despesa o solicitante deverá prestar conta da solicitação de despesas principal e das solicitações complementares.',cCadastro)
			aArea := PAD->(GetArea())
			PAD->(dbSetOrder(1))
			PAD->(dbSeek(xFilial('PAD')+PAD->PAD_NUMERO))
			While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL == xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
				nComplemento++
				cPAD_COMPL := PAD->PAD_COMPL
				PAD->(dbSkip())
			End
			PAD->(RestArea(aArea))
			If nComplemento <= 4
				SX3->(dbSetOrder(1))
				SX3->(dbSeek('PAD'))
				While SX3->(.NOT. EOF()) .And. SX3->X3_ARQUIVO == 'PAD'
					If X3USO(SX3->X3_USADO)
						AAdd(aAcho,SX3->X3_CAMPO)
						If RTrim(SX3->X3_CAMPO) $ cCpos
							AAdd(aCpos,SX3->X3_CAMPO)
						Endif
					Endif
					SX3->(dbSkip())
				End		
				If AxInclui( cAlias, nRecNo, nOpc,aAcho,'U_A260Cpos()', aCpos, 'U_A260TOkInc()' )==1
					PAD->(RecLock('PAD',.F.))
					PAD->PAD_STATUS := '1'
					PAD->(MsUnLock())
				Endif
			Else
				MsgAlert('Atenção, somente é possível fazer até 3 complementos, ou seja, uma solicitação de despesa e mais três complementos.',cCadastro)
			Endif
		Else
			MsgAlert('Por favor, posicione na solicitação de despesa principal para fazer o complemento de despesa.',cCadastro)
		Endif
	Else
		MsgAlert('Somente solicitação de despesas aprovada poderá ser complementada.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260Cpos   | Autor | Robson Gonçalves     | Data | 08.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para controlar quais campos será editados e formar a 
//        | sequencia do complemento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Cpos()
	M->PAD_NUMERO := PAD->PAD_NUMERO
	M->PAD_COMPL  := Soma1(cPAD_COMPL,Len(PAD->PAD_COMPL))
	M->PAD_CC     := PAD->PAD_CC
	M->PAD_CONTA  := PAD->PAD_CONTA
	M->PAD_ITCTB  := PAD->PAD_ITCTB
	M->PAD_CLVL   := PAD->PAD_CLVL
	M->PAD_SOLICI := PAD->PAD_SOLICI
	M->PAD_NOMSOL := PAD->PAD_NOMSOL
	M->PAD_NOMOPE := RetCodUsr()
	M->PAD_USUAPR := PAD->PAD_USUAPR
	M->PAD_UF     := PAD->PAD_UF
	M->PAD_DTAPR  := MsDate()	
	M->PAD_BANCO  := PAD->PAD_BANCO
	M->PAD_AGENCI := PAD->PAD_AGENCI
	M->PAD_DVAGEN := PAD->PAD_DVAGEN
	M->PAD_NUMCTA := PAD->PAD_NUMCTA
	M->PAD_DVCTA  := PAD->PAD_DVCTA
Return

//-----------------------------------------------------------------------
// Rotina | A260Canc   | Autor | Robson Gonçalves     | Data | 11.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de cancelamento de aprovação e rejeição.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260Canc( cAlias, nRecNo, nOpc )
	Local aSay := {}
	Local aButton := {}
	Local aCompl := {}
	
	Local nI := 0
	Local nOpcao := 0
	
	Local cMsg := ''
	Local cPAD_NUMERO := ''
	Local cPAD_STATUS := PAD->PAD_STATUS
	
	If cPAD_STATUS $ '1|2'
		If PAD->PAD_COMPL == '0'
			AAdd( aSay, 'Esta ação permite ao usuário cancelar a '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' da solicitação de despesa em questão.')
			AAdd( aSay, '' )
			AAdd( aSay, 'Clique em OK para prosseguir.')
			AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
			AAdd( aButton, { 22, .T., { || FechaBatch() } } )
			FormBatch( cCadastro, aSay, aButton )
			If nOpcao==1
				cMsg := 'Deseja realmente CANCELAR a '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' da solicitação de despesa?'
				If MsgYesNo(cMsg,cCadastro)					
					cPAD_NUMERO := PAD->PAD_NUMERO
					If cPAD_STATUS=='1'
						While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
							AAdd(aCompl,PAD->(RecNo()))
							PAD->(dbSkip())
						End
						If Len(aCompl)>1
							MsgInfo('Foi identificado que há complemento(s) de solicitação de despesas, por isso este(s) complemento(s) será(ão) apagado(s).',cCadastro)
						Endif
						For nI := 1 To Len(aCompl)
							PAD->(dbGoTo(aCompl[nI]))
							PAD->(RecLock('PAD',.F.))
							If nI==1
								PAD->PAD_STATUS := '0'
								PAD->PAD_USUAPR := ''
								PAD->PAD_DTAPR  := Ctod('  /  /  ')
							Else
								PAD->(dbDelete())
							Endif
							PAD->(MsUnLock())
						Next nI
						PAD->(dbSeek(xFilial('PAD')+cPAD_NUMERO))
					Else
						PAD->(RecLock('PAD',.F.))
						PAD->PAD_STATUS := '0'
						PAD->PAD_MOTREJ := ''
						PAD->PAD_USUREJ := ''
						PAD->PAD_DTREJ  := Ctod('  /  /  ')
						PAD->(MsUnLock())
					Endif
					MsgInfo('Operação de cancelamento da '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' realizada com sucesso.',cCadastro)
				Endif
			Endif
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Não é possível cancelar ações que não seja aprovação ou rejeição de solicitação de despesa.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260New    | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para estabelecer as novas ou antigas funcionalidades.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260New()
	Local cMV_260NEW := 'MV_260NEW'
	If .NOT. GetMv( cMV_260NEW, .T. )
		CriarSX6( cMV_260NEW, 'N', 'HABILITAR NOVA SOLICITACAO DE DESPESA COM CONTROLE DE APROVACAO POR WF. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA260.prw', '1' )
	Endif
Return( GetMv( cMV_260NEW, .F. ) == 1 )

//-----------------------------------------------------------------------
// Rotina | A260SApr   | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para submeter a aprovação da solicitação de compras.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260SApr()
	Local lRet := .F.
	Local cMV_260PREF := 'MV_260PREF'
	Local cMV_260TIPO := 'MV_260TIPO'
	Local cMV_260NATU := 'MV_260NATU'
	
	If .NOT. GetMv( cMV_260PREF, .T. )
		CriarSX6( cMV_260PREF, 'C', 'PREFIXO DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260', '' )
	Endif
	cMV_260PREF := GetMv( cMV_260PREF, .F. )

	If .NOT. GetMv( cMV_260TIPO, .T. )
		CriarSX6( cMV_260TIPO, 'C', 'TIPO DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260', '' )
	Endif
	cMV_260TIPO := GetMv( cMV_260TIPO, .F. )

	If .NOT. GetMv( cMV_260NATU, .T. )
		CriarSX6( cMV_260NATU, 'C', 'NATUREZA DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260.prw', '' )
	Endif
	cMV_260NATU := GetMv( cMV_260NATU, .F. )
	
	// O campo tipo de despesa existe?
	If PAD->( FieldPos( 'PAD_TPDESP' ) ) > 0
		// O status do registro é solicitado ou aguardando aprovação?
		If PAD->PAD_STATUS $ '0|5'
			// O tipo de despesa foi informado?
			If PAD->PAD_TPDESP $ '1|2
				// Existe o tipo de título no parâmetro?
				If .NOT. Empty( cMV_260TIPO )
					// Existe a natureza do título no parâmetro?
					If .NOT. Empty( cMV_260NATU )
						// Verificar se o participante está cadastrado como fornecedor.
						If A260IsForn( PAD->PAD_SOLICI )
							// Avaliar se é para enviar ou reenviar o WF.
							lReenviar := ( A260Avaliar()==2 )
							If lReenviar
								A260Reenviar()
							Else
								A260Enviar()
							Endif
						Endif
					Else
						MsgAlert(cFONT_V+'ATENÇÃO! <br>'+cFONT+'Não será possível continuar com a aprovação da solicitação de despesas, <br>'+;
						'falta informar Natureza no parâmetro "MV_260NATU".'+cNOFONT,cCadastro)
					Endif
				Else
					MsgAlert(cFONT_V+'ATENÇÃO! <br>'+cFONT+'Não será possível continuar com a aprovação da solicitação de despesas, <br>'+;
					'falta informar Tipo no parâmetro "MV_260TIPO".'+cNOFONT,cCadastro)
				Endif
			Else
				MsgAlert(cFONT_V+'ATENÇÃO! <br>'+cFONT+'A solicitação de despesa está sem a definição do tipo de despesa - Adiantamento ou Reembolso.'+cNOFONT,cCadastro)
			Endif
		Else
			MsgAlert(cFONT_V+'ATENÇÃO! <br>'+cFONT+'Somente solicitação de despesa em fase de solicitação <br>é que poderá ser solicitado aprovação.'+cNOFONT,cCadastro)
		Endif
	Else
		MsgAlert(cFONT_V+'ATENÇÃO! <br>'+cFONT+'É preciso executar o update "UPD260" para criar o campo "Tipo de Despesa (PAD_TPDESP)", <br>'+;
		'sem a execução deste update é impossível continuar com o Controle de Despesas.'+cNOFONT,cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260IsForn | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se o participante está cadastrado como 
//        | fornecedor.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260IsForn( cPAD_SOLICI )
	Local lRet := .T.
	RD0->( dbSetORder( 1 ) )
	RD0->( dbSeek( xFilial( 'RD0' ) + cPAD_SOLICI ) )
	If .NOT. Empty( RD0->RD0_CIC )
		SA2->( dbSetOrder( 3 ) )
		If .NOT. SA2->( dbSeek( xFilial( 'SA2' ) + RD0->RD0_CIC ) )
			lRet := .F.
			MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>O solicitante '+RTrim( M->RD0_NOME )+' não está cadastrado como FORNECEDOR, por favor, <br> providencie este cadastro para seguir '+;
			'com a solicitação de aprovação.'+cNOFONT,cCadastro)
		Endif
	Else
		lRet := .F.
		MsgAlert( cFONT_V + 'ATENÇÃO' + cFONT + '<br>O participante está sem CPF.' + cNOFONT, cCadastro )
	Endif
Return( lRet )
//-----------------------------------------------------------------------
// Rotina | A260Avaliar| Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para avaliar o registro se pode submeter a aprovação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260Avaliar()
	Local nReturn := 0
	SCR->( dbSetOrder( 1 ) )
	If SCR->( dbSeek( xFilial( 'SCR' ) + cTP_DOC + PadR( PAD->PAD_NUMERO, Len( SCR->CR_NUM ), ' ' ) ) )
		If SCR->CR_STATUS == '02'
			nReturn := 2
		Else
			If SCR->CR_STATUS == '03'
				MsgAlert(cFONT+'Solicitação de Despesa APROVADA.'+cNOFONT,cCadastro)
			Elseif SCR->CR_STATUS == '04'
				MsgAlert(cFONT+'Solicitação de Despesa REJEITADA.'+cNOFONT,cCadastro)
			Endif	
		Endif
	Else
		nReturn := 1
	Endif
Return( nReturn )

//-----------------------------------------------------------------------
// Rotina | A260Enviar | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de interface com o objetivo da rotina para o 
//        | conhecimento do usuário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260Enviar()
	Local nOpc := 0
	Local aSay := {}
	Local aButton := {}
	
	AAdd( aSay, 'Rotina para solicitar aprovação da solicitação de despesas. Esta rotina irá acionar o nível 1' )
	AAdd( aSay, 'do grupo de aprovação conforme informado no centro de custo desta solicitação de' )
	AAdd( aSay, 'despesa.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
			
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
			
	FormBatch( cCadastro, aSay, aButton )
			
	If nOpc == 1
		FWMsgRun( , {|| A260SolApr() }, ,'Enviando workflow da solicitação de despesa...' )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260Reenviar | Autor | Robson Gonçalves   | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para confirmar se é o reenvio que o usuário deseja.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260Reenviar()
	If Aviso( cCadastro,'Estou aguardando a análise da solicitação de despesa nº '+PAD->PAD_NUMERO+;
	   ' pelo o usuário '+RTrim( UsrFullName( SCR->CR_USER ) )+'. Quer reenviar o workflow agora?',{'Reenviar','Não'},2,'Solicitar análise') == 1
		FWMsgRun( , {|| A260SolApr( .T. ) }, ,'Enviando workflow da solicitação de despesa...' )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260SolApr | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para solicitar aprovação via WF.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260SolApr( lReenviar )
	Local cSQL := ''
	Local cTRB := ''
	Local cField := ''
	Local cGrpAprov := ''
	Local cMV_260GRAP := 'MV_260GRAP'
	
	DEFAULT lReenviar := .F. 
	
	If .NOT. GetMv( cMV_260GRAP, .T. )
		CriarSX6( cMV_260GRAP, 'C', 'CAMPO NO CENTRO DE CUSTO COM O CODIGO DO GRUPO DE APROVACAO PARA APROVAR SOLICITACAO DE DESPESA COM CONTROLE DE APROVACAO POR WF. - ROTINA CSFA260.prw', 'CTT_GAPONT' )
	Endif
	
	cMV_260GRAP := GetMv( cMV_260GRAP, .F. )
	
	cField := 'CTT->(FieldPos("'+cMV_260GRAP+'")) > 0'
	
	If &( cField )
		cGrpAprov := Posicione( 'CTT', 1, xFilial( 'CTT' ) + PAD->PAD_CC, cMV_260GRAP )
		If Empty( cGrpAprov )
			MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>Não será possível enviar solicitação de aprovação por workflow,<br> '+;
			'pois o campo Grupo de Aprovação "'+cMV_260GRAP+'" do cadastro de centro de custo '+PAD->PAD_CC+' não está preenchido.'+cNOFONT,cCadastro)
		Else
			If lReenviar
				 // Apenas capturar os dados e reenviar o WF.
				A260WF()
			Else
				 // Verificar se o Participante (RD0) em questão já é fornecedor (SA2).
				 SA2->( dbSetOrder( 3 ) )
				 If SA2->( dbSeek( xFilial( 'SA2' ) + RD0->RD0_CIC ) )
					 // Buscar o aprovador conforme o grupo de aprovação pontual do centro de custo.
					 // Este aprovador deve ser do nível 01.
					 // Deve ser aprovador.
					 // Deve possui tipo de liberação igual a pedido.
					 // O registro não pode estar bloqueado para uso.
					cSQL := "SELECT AL_APROV, AL_USER, AL_NIVEL "
					cSQL += "FROM   "+RetSqlName("SAL")+" SAL "
					cSQL += "WHERE  AL_FILIAL = "+ValToSql( xFilial( "SAL" ) )+" "
					cSQL += "       AND AL_COD = "+ValToSql( cGrpAprov )+" "
					cSQL += "       AND AL_NIVEL = '01' "
					cSQL += "       AND AL_LIBAPR = 'A' "
					cSQL += "       AND AL_TPLIBER = 'P' "
					cSQL += "       AND AL_MSBLQL <> '1' "
					cSQL += "       AND SAL.D_E_L_E_T_ = ' ' "
					cSQL += "ORDER  BY AL_FILIAL, AL_COD, AL_NIVEL "
					cSQL := ChangeQuery( cSQL )
					cTRB := GetNextAlias()
					dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
					If (cTRB)->(BOF()) .AND. (cTRB)->(EOF())
						(cTRB)->( dbCloseArea() )
						MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>Não será possível enviar solicitação de aprovação por workflow.<br> '+;
						'Não foi localizado aprovador com alçada para autorizar a solicitação de despesas.'+cNOFONT,cCadastro)
					Else
						A260GrvSCR( cTRB )
						A260WF()
						(cTRB)->( dbCloseArea() )
					Endif
				 Else
				 	MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>O solicitante '+RTrim( RD0->RD0_NOME )+' não está cadastrado como FORNECEDOR, por favor, <br> providencie este cadastro para seguir '+;
				 	'com a solicitação de aprovação.'+cNOFONT,cCadastro)
				 Endif
			Endif
		Endif
	Else
		MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>Não será possível enviar solicitação de aprovação por workflow.<br> '+;
		'Não foi localizado o campo '+cMV_260GRAP+' informado no parâmetro MV_260GRAP.'+cNOFONT,cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260GrvSCR | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar os registros na tabela de alçada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260GrvSCR( cTRB )
	SCR->( RecLock( 'SCR', .T. ) )
	SCR->CR_FILIAL  := xFilial( 'SCR' )
	SCR->CR_NUM     := PAD->PAD_NUMERO
	SCR->CR_TIPO    := cTP_DOC //Aprovação automática da solicitação de despesas (CSFA260).
	SCR->CR_USER    := (cTRB)->AL_USER
	SCR->CR_APROV   := (cTRB)->AL_APROV
	SCR->CR_NIVEL   := (cTRB)->AL_NIVEL
	SCR->CR_STATUS  := '02' //Aguardando liberação do usuário.
	SCR->CR_OBS     := 'APROV. SOLICIT.DESPESA CSFA260'
	SCR->CR_TOTAL   := PAD->PAD_VLRADI
	SCR->CR_EMISSAO := dDataBase
	SCR->CR_MOEDA   := 1
	SCR->CR_TXMOEDA := 1
	SCR->( MsUnLock() )
Return

//-----------------------------------------------------------------------
// Rotina | A260WF     | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de início do workflow de aprovação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260WF()
	Local nI := 0
	Local oWFEnv  
	Local oHTML	
	Local cTitulo := ''
	Local cCampo := ''
	Local cIdMail := ''
	Local cCpo := ''
	Local cInf := ''
	Local aTITLE := {}
	Local aDADOS := {}
	Local aUSR_APROV := {}
	Local cPAD_USUAPR := SCR->CR_USER
	Local aPAD_TPDESP := StrToKarr( Posicione( 'SX3', 2, 'PAD_TPDESP', 'X3CBox()' ), ';' )
	
	Private cMV_260WF1 := GetNewPar('MV_260WF1', '\WORKFLOW\EVENTO\CSFA260a.HTM')
	Private cMV_260WF2 := GetNewPar('MV_260WF2', '\WORKFLOW\EVENTO\CSFA260b.HTM')
	
	PswOrder( 1 )
	PswSeek( cPAD_USUAPR )
	aUSR_APROV := PswRet(1)

	AAdd( aTITLE, 'Nº Solicitação de despesa' ) //1
	AAdd( aTITLE, 'Emissão' ) //2
	AAdd( aTITLE, 'Centro de custo' ) //3
	AAdd( aTITLE, 'Descrição do c. custo' ) //4
	AAdd( aTITLE, 'Código do solicitante' ) //5
	AAdd( aTITLE, 'Nome do solicitante' ) //6
	AAdd( aTITLE, 'Período de/até' ) //7
	AAdd( aTITLE, 'Tipo de despesa' ) //8
	AAdd( aTITLE, 'Motivo' ) //9
	AAdd( aTITLE, 'Descrição do motivo' ) //10
	AAdd( aTITLE, 'Valor' ) //11
	AAdd( aTITLE, 'Código do elaborador' ) //12
	AAdd( aTITLE, 'Nome do elaborador' ) //13
	AAdd( aTITLE, 'Código do aprovador' ) //14
	AAdd( aTITLE, 'Nome do aprovador' ) //15
	
   AAdd( aDADOS, PAD->(PAD_FILIAL + '-' + PAD_NUMERO) )
   AAdd( aDADOS, Dtoc( PAD->PAD_EMISSA ) )
   AAdd( aDADOS, PAD->PAD_CC )
   AAdd( aDADOS, Posicione('CTT',1,xFilial('CTT')+PAD->PAD_CC,'CTT_DESC01') )
   AAdd( aDADOS, PAD->PAD_SOLICI )
   AAdd( aDADOS, Posicione('RD0',1,xFilial('RD0')+PAD->PAD_SOLICI,'RD0_NOME') )
   AAdd( aDADOS, Dtoc( PAD->PAD_PERDE ) + ' até ' + Dtoc( PAD->PAD_PERATE ) )
   AAdd( aDADOS, aPAD_TPDESP[ Val( PAD->PAD_TPDESP ) ] )
   AAdd( aDADOS, PAD->PAD_MOT )
   AAdd( aDADOS, PAD->PAD_MOTIVO )
   AAdd( aDADOS, LTrim( TransForm( PAD->PAD_VLRADI, '@E 999,999,999.99' ) ) )
   AAdd( aDADOS, PAD->PAD_OPERAD )
   AAdd( aDADOS, UsrFullName( PAD->PAD_OPERAD ) )
   AAdd( aDADOS, cPAD_USUAPR )
   AAdd( aDADOS, aUSR_APROV[ 1, 4 ] )
	
	oWFEnv := TWFProcess():New( 'SOLDESPWF', 'Solicitação de de despesa')
	oWFEnv:NewTask( 'SOLDESPWF', cMV_260WF1 )
	oWFEnv:cSubject := 'Solicitação de Despesa'
	oWFEnv:bReturn := 'U_CSFA260A(1)'
	oWFEnv:bTimeOut := {{'U_CSFA260A(2)', 1 ,0 ,0 }} // Nome da rotina, dias, hora, minuto.
	
	oHTML := oWFEnv:oHTML
	
	oHTML:ValByName( 'cPrezado', RTrim( aUSR_APROV[ 1, 4 ] ) )
	
	For nI := 1 To Len( aTITLE )
		cCpo := 'cTitulo' + LTrim( Str( nI ) )
		cInf := 'cCampo' + LTrim( Str( nI ) )
		
		oHTML:ValByName( cCpo, aTITLE[ nI ] )
		oHTML:ValByName( cInf, aDADOS[ nI ] )
	Next nI
	
	oWFEnv:cTo := StrTran( StrTran( aUSR_APROV[ 1, 2 ], ".", "" ), "\", "" )
	
	oWFEnv:FDesc := 'Aprovar Solicitação de Despesa nº '+ PAD->PAD_NUMERO
	
	oWFEnv:ClientName( aUSR_APROV[ 1, 2 ] )
	
	cIdMail := oWFEnv:Start()
	
	A260WFLink( aTITLE, aDADOS, @oWFEnv, cIdMail, aUSR_APROV )
	
	oWFEnv:Free()
	
	PAD->( RecLock( 'PAD', .F. ) )
	PAD->PAD_STATUS := '5'
	PAD->( MsUnLock() )
	
	MsgInfo(cFONT+'Operação efetuada com sucesso!'+cNOFONT, cCadastro)
Return

//-----------------------------------------------------------------------
// Rotina | A260WFLink | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para elaborar o html com o link de aprovação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260WFLink( aTITLE, aDADOS, oWFEnv, cIdMail, aUSR_APROV )
	Local nI := 0
	Local cTitulo := ''
	Local cCampo := ''
	Local oHTML
	Local cEMail := ''
	Local cLink	:= GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
	Local cLinkUser := StrTran( StrTran( aUSR_APROV[ 1, 2 ], ".", "" ), "\", "" )
	Local cCpo := ''
	Local cInf := ''
	
	cEMail := aUSR_APROV[ 1, 14 ]

	cLink += 'emp' + cEmpAnt + '/'

	oWFEnv:NewTask( 'SOLDESPWF', cMV_260WF2 )
	oWFEnv:cSubject := 'Aprovar Solicitação de Despesa nº '+ PAD->PAD_NUMERO
	oWFEnv:cTo := cEMail
	
	oHTML := oWFEnv:oHTML
	
	oHTML:ValByName( 'cPrezado', RTrim( aUSR_APROV[ 1, 4 ] ) )

	For nI := 1 To Len( aTITLE )
		cCpo := 'cTitulo' + LTrim( Str( nI ) )
		cInf := 'cCampo' + LTrim( Str( nI ) )
		
		oHTML:ValByName( cCpo, aTITLE[ nI ] )
		oHTML:ValByName( cInf, aDADOS[ nI ] )
	Next nI

	oHTML:ValByName( 'proc_link', cLink + cLinkUser + '/' + cIdMail + '.htm' )
	oHTML:ValByName( 'titulo', cIdMail )
	
	oWFEnv:Start()
	oWFEnv:Free()
Return

//-----------------------------------------------------------------------
// Rotina | CSFA260A   | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para receber o retorno do WF de aprovação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA260A( nOPC, o260Proc )
	If nOPC == 1
		Begin Transaction
			A260RetWF( o260Proc )
		End Transaction
	Elseif nOPC == 2
		A260TimeOut( o260Proc )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260TimeOut | Autor | Robson Gonçalves    | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para fazer o TimeOut do workflow.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260TimeOut( o260Proc )
	Local cCR_FILIAL := ''
	Local cCR_NUM    := ''
	
	cCR_FILIAL := SubStr( AllTrim( o260Proc:oHTML:RetByName('cCampo1') ), 1, 2 )
	cCR_NUM    := SubStr( AllTrim( o260Proc:oHTML:RetByName('cCampo1') ), 4, 6 )
	
	PAD->( dbSetOrder( 1 ) )
	If PAD->( dbSeek( cCR_FILIAL + cCR_FILIAL ) )
		If PAD->PAD_STATUS $ '0|5'
			A260SolApr( .T. )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260RetWF  | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento do workflow.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260RetWF( o260Proc )
	Local nI := 0
	Local nDias := 0
	
	Local cMotivo := ''
	Local cAprovacao := ''
	Local cWFMailID := ''
	Local cSituacao := ''
	Local cCR_STATUS := ''
	Local cCR_FILIAL := ''
	Local cCR_NUM := ''
	Local cPAD_VLRADI := ''
	Local cPAD_TPDESP := ''
	Local cPAD_STATUS := ''
	Local cNomAutLog := ''
	Local cConteuLog := ''
	Local cMV_260EMCP := 'MV_260EMCP'
	Local cMV_260PREF := 'MV_260PREF'
	Local cMV_260TIPO := 'MV_260TIPO'
	Local cMV_260NATU := 'MV_260NATU'
	Local cMV_260BANC := 'MV_260BANC'
	Local cMV_260DIPA := 'MV_260DIPA'
	Local cMV_260DITF := 'MV_260DITF'
	
	Local dE1_VENCTO := Ctod( Space( 8 ) )
	
	Local aSE2 := {}
	Local aSend := {}
	
	Local lSCR := .F.
	Local lPAD := .F.
	Local lSE2 := .F.

	Private lMsErroAuto := .F.
	
	If .NOT. GetMv( cMV_260EMCP, .T. )
		CriarSX6( cMV_260EMCP, 'C', 'E-MAIL E NOME DO USUÁRIO DO CONTAS A PAGAR - ROTINA CSFA260.prw', 'ctapag@certisign.com.br' )
	Endif
	cMV_260EMCP := GetMv( cMV_260EMCP, .F. )
	
	If .NOT. GetMv( cMV_260PREF, .T. )
		CriarSX6( cMV_260PREF, 'C', 'PREFIXO DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260', 'CD' )
	Endif
	cMV_260PREF := GetMv( cMV_260PREF, .F. )
	
	If .NOT. GetMv( cMV_260TIPO, .T. )
		CriarSX6( cMV_260TIPO, 'C', 'TIPO DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260', 'PA#TF' )
	Endif
	cMV_260TIPO := GetMv( cMV_260TIPO, .F. )
	
	If .NOT. GetMv( cMV_260NATU, .T. )
		CriarSX6( cMV_260NATU, 'C', 'NATUREZA DO TITULO A PAGAR INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260.prw', 'SF115004#SA090004' )
	Endif
	cMV_260NATU := GetMv( cMV_260NATU, .F. )
	
	If .NOT. GetMv( cMV_260BANC, .T. )
		CriarSX6( cMV_260BANC, 'C', 'NÚMERO DO BANCO, AGENCIA E CONTA PARA INCLUSAO DO PA INTEGRADO COM A SOLICITACAO DE DESPESA - ROTINA CSFA260.prw', '341#8738#01641-2' )
	Endif
	cMV_260BANC := GetMv( cMV_260BANC, .F. )
	
	If .NOT. GetMv( cMV_260DIPA, .T. )
		CriarSX6( cMV_260DIPA, 'N', 'DIAS PARA VENCER O TITULO (PA) APOS A APROVACAO DO WF - ROTINA CSFA260.prw', '3' )
	Endif
	cMV_260DIPA := GetMv( cMV_260DIPA, .F. )

	If .NOT. GetMv( cMV_260DITF, .T. )
		// 1=DOMINGO, 2=SEGUNDA, 3=TERÇA, 4=QUARTA, 5=QUINTA, 6=SEXTA, 7=SÁBADO.
		CriarSX6( cMV_260DITF, 'N', 'NUMERO DO DIA DA SEMANA PARA VENCER O TITULO DE REEMBOLSO APOS A APROVACAO DO WF - ROTINA CSFA260.prw', '5' )
	Endif
	cMV_260DITF := GetMv( cMV_260DITF, .F. )
	
	cWFMailID   := SubStr( RTrim( o260Proc:oHTML:RetByName('WFMailID') ), 3 )
	
	// Salvar o ID do WF.
	U_A603Save( cWFMailID, 'CSFA260' )
	
	cCR_FILIAL  := SubStr( AllTrim( o260Proc:oHTML:RetByName('cCampo1') ), 1, 2 )
	cCR_NUM     := PadR( SubStr( AllTrim( o260Proc:oHTML:RetByName('cCampo1') ), 4, 6 ), Len( SCR->CR_NUM ), ' ' )
	cMotivo     := RTrim( o260Proc:oHTML:RetByName('cMotivo') )
	cAprovacao  := RTrim( o260Proc:oHTML:RetByName('cAprovacao') )
	cPAD_VLRADI := RTrim( o260Proc:oHTML:RetByName('cCampo11') )
	cPAD_TPDESP := RTrim( o260Proc:oHTML:RetByName('cCampo8') )
	
	AAdd( aSend, { RTrim( o260Proc:oHTML:RetByName('cCampo5') ) , RTrim( o260Proc:oHTML:RetByName('cCampo6') ) , '' } ) //Código, Nome, E-Mail do solicitante (RD0).
	AAdd( aSend, { RTrim( o260Proc:oHTML:RetByName('cCampo12') ), RTrim( o260Proc:oHTML:RetByName('cCampo13') ), '' } ) //Código, Nome, E-Mail do elaborador.
	AAdd( aSend, { RTrim( o260Proc:oHTML:RetByName('cCampo14') ), RTrim( o260Proc:oHTML:RetByName('cCampo15') ), '' } ) //Código, Nome, E-Mail do aprovador.
	
	For nI := 1 To Len( aSend )
		If nI == 1
			aSend[ nI, 3 ] := Posicione( 'RD0', 1, xFilial( 'RD0' ) + aSend[ nI, 1 ], 'RD0_EMAIL' )
		Else
			aSend[ nI, 3 ] := UsrRetMail( aSend[ nI, 1 ] )
		Endif
	Next nI
	
	nI := At( '|', cMV_260EMCP )
	
	If nI > 0
		AAdd( aSend, { '', SubStr( cMV_260EMCP, nI+1 ), SubStr( cMV_260EMCP, 1, nI-1 )  } )
	Endif

	// Agir na liberação e/ou rejeição.
	If cAprovacao $ 'S|N'
		If cAprovacao == 'S'
			cPAD_STATUS := '1'
			cCR_STATUS  := '03'
			cSituacao   := 'Aprovada'
		Else
			cPAD_STATUS := '2'
			cCR_STATUS  := '04'
			cSituacao   := 'Rejeitada'
		Endif
		
		cSituacao := cSituacao + ' - ' + cPAD_TPDESP
		
		If .NOT. Empty( cCR_STATUS ) .AND. .NOT. Empty( cSituacao )
			If SCR->( dbSeek( cCR_FILIAL + cTP_DOC + cCR_NUM ) )
				lSCR := .T.
				While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == cCR_FILIAL .AND. SCR->CR_NUM == cCR_NUM
					SCR->( RecLock( 'SCR', .F. ) )
					SCR->CR_STATUS  := cCR_STATUS // 03-Liberado pelo usuario ou 04-Bloqueado pelo usuario.
					SCR->CR_DATALIB := dDataBase
					SCR->( MsUnLock() )
					SCR->( dbSkip() )
				End
			Endif
			
			If lSCR
				PAD->( dbSetOrder( 1 ) )
				If PAD->( dbSeek( cCR_FILIAL + RTrim( cCR_NUM ) + '0' ) )
					lPAD := .T.
					PAD->( RecLock( 'PAD', .F. ) )
					PAD->PAD_STATUS := cPAD_STATUS // 1-Aprovado ou 2-Rejeitado.
					If cPAD_STATUS == '1'
						PAD->PAD_USUAPR := aSend[ 3, 1 ]
						PAD->PAD_DTAPR  := MsDate()
					Else
						PAD->PAD_USUREJ := aSend[ 3, 1 ]
						PAD->PAD_DTREJ  := MsDate()
					Endif
					If .NOT. Empty( cMotivo )
						PAD->PAD_MOTREJ := cMotivo
					Endif
					PAD->(MsUnLock())
				Endif
			Endif
			
			If lSCR .AND. lPAD
				RD0->( dbSetOrder( 1 ) )
				RD0->( dbSeek( xFilial( 'RD0' ) + PAD->PAD_SOLICI ) )
			
				SA2->( dbSetOrder( 3 ) )
				SA2->( dbSeek( xFilial( 'SA2' ) + RD0->RD0_CIC ) )
				
				If PAD->PAD_TPDESP == '1' //Adiantamento
					cMV_260TIPO := SubStr( cMV_260TIPO, 1, At( '#', cMV_260TIPO )-1 )
					cMV_260NATU := SubStr( cMV_260NATU, 1, At( '#', cMV_260NATU )-1 )
					dE1_VENCTO  := MsDate() + cMV_260DIPA
				Else
					cMV_260TIPO := SubStr( cMV_260TIPO, At( '#', cMV_260TIPO )+1 )
					cMV_260NATU := SubStr( cMV_260NATU, At( '#', cMV_260NATU )+1 )
					// Faça até achar a data.
					While .T.
						// Somar dias
						nDias++
						// É quinta-feira?
						If Dow( MsDate() + nDias ) == cMV_260DITF
							// É maior ou igual que 7 dias?
							If nDias >= 7
								dE1_VENCTO := MsDate() + nDias + 1
								Exit
							Endif
						Endif
					End
				Endif
			
				AAdd( aSE2, { 'E2_PREFIXO', cMV_260PREF, NIL } )
				AAdd( aSE2, { 'E2_NUM'    , RTrim( cCR_NUM ), NIL } )
				AAdd( aSE2, { 'E2_PARCELA', Space( Len( SE2->E2_PARCELA ) ), NIL } )
				AAdd( aSE2, { 'E2_TIPO'   , cMV_260TIPO, NIL } )
				AAdd( aSE2, { 'E2_NATUREZ', cMV_260NATU, NIL } )
				AAdd( aSE2, { 'E2_FORNECE', SA2->A2_COD, NIL } )
				AAdd( aSE2, { 'E2_LOJA'   , SA2->A2_LOJA, NIL } )
				AAdd( aSE2, { 'E2_EMISSAO', dDataBase, NIL } )
				AAdd( aSE2, { 'E2_VENCTO' , dDataBase, NIL } )
				AAdd( aSE2, { 'E2_VENCREA', DataValida( dE1_VENCTO ), NIL } )
				AAdd( aSE2, { 'E2_VALOR'  , Val( StrTran( StrTran( cPAD_VLRADI , '.', ''  ), ',', '.' ) ), NIL } )
				AAdd( aSE2, { 'E2_CCD'    , PAD->PAD_CC, NIL } )
				AAdd( aSE2, { 'E2_ITEMD'  , PAD->PAD_ITCTB, NIL } )
				AAdd( aSE2, { 'E2_CLVLDB' , PAD->PAD_CLVL, NIL } )
				
				If PAD->PAD_TPDESP == '1' //Adiantamento
					AAdd( aSE2, { 'AUTBANCO'  , SubStr( cMV_260BANC, 1, AT( '#', cMV_260BANC )-1 ), NIL } )
					AAdd( aSE2, { 'AUTAGENCIA', SubStr( cMV_260BANC, AT( '#', cMV_260BANC )+1, (RAT( '#', cMV_260BANC )-AT( '#', cMV_260BANC ))-1 ), NIL } )
					AAdd( aSE2, { 'AUTCONTA'  , SubStr( cMV_260BANC, RAT( '#', cMV_260BANC )+1 ), NIL } )
				Endif
				
				MSExecAuto( {|x,y| FINA050( x, y ) }, aSE2, 3 )
				
				If lMsErroAuto
					cNomAutLog := NomeAutoLog()
					cConteuLog := MemoRead( cNomAutLog )
					If .NOT. Empty( cNomAutLog ) .OR. .NOT. Empty( cConteuLog )
						FSSendMail( ;
						'sistemascorporativos@certisign.com.br', ;
						'CSFA260 - Não gerou contas a pagar.', ;
						'Não foi possível gerar título a pagar para a solicitação de despesa Nº '+RTrim( cCR_NUM ) +Chr( 13 ) + Chr( 10 ) + cConteuLog, ;
						cNomAutLog )
					Endif
				Else
					lSE2 := .T.
				Endif
			Endif
			If lSCR .AND. lPAD .AND. lSE2
				A260MsgUser( cSituacao, cMotivo, RTrim( cCR_NUM ), aSend, cPAD_VLRADI )
			Endif
	   Endif
   Endif
Return

//-----------------------------------------------------------------------
// Rotina | A260MsgUser| Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar aviso aos usuário quanto ao resultado da 
//        | aprovação do WF.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A260MsgUser( cSITUACAO, cMOTIVO, cCR_NUM, aSend, cPAD_VLRADI )
	Local nI := 0
	Local cMail := ''
	Local cHTML := ''
	Local cHTML_Aux := ''
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
	cHTML += '		<title>Aprova&ccedil;&atilde;o do pedido de compras</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><font color="#F4811D" face="Arial, Helvetica, sans-serif" size="5"><strong>An&aacute;lise da Solicita&ccedil;&atilde;o de Despesas</strong></font><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
	cHTML += '						<p>'
	cHTML += '							&nbsp;</p>'
	cHTML += '					</td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<font color="#333333" face="Arial, Helvetica, sans-serif" size="2">Sr.(a) __PREZADO__,<br />'
	cHTML += '							<br />'
	cHTML += '							Este e-mail &eacute; informativo com o resultado da an&aacute;lise da aprova&ccedil;&atilde;o da solicita&ccedil;&atilde;o de despesa. </font></p>'
	cHTML += '						<p>'
	cHTML += '							<font color="#333333" face="Arial, Helvetica, sans-serif" size="2">Por favor, qualquer necessidade procurar o respons&aacute;vel pela a a&ccedil;&atilde;o. </font></p>'
	cHTML += '						<hr />'
	cHTML += '						<table align="center" border="0" cellpadding="1" cellspacing="1" style="height: 160px; width: 400px">'
	cHTML += '							<tbody>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">N&ordm; Solicit. Desp.:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cCR_NUM+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; border-color: rgb(254, 219, 171); vertical-align: middle;">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Solicitante:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+RTrim( aSend[ 1, 2 ] )+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Valor:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cPAD_VLRADI+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Situa&ccedil;&atilde;o:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; border-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cSITUACAO+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="text-align: right; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<strong><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Motivo:&nbsp;</span></strong></td>'
	cHTML += '									<td style="text-align: left; vertical-align: middle; background-color: rgb(254, 219, 171);">'
	cHTML += '										<span style="font-size:11px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">&nbsp;'+cMOTIVO+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '							</tbody>'
	cHTML += '						</table>'
	cHTML += '						<hr />'
	cHTML += '						<p>'
	cHTML += '							<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Qualquer d&uacute;vida verfique a referida solicita&ccedil;&atilde;o de despesa no sistema de gest&atilde;o</span><font color="#333333" face="Arial, Helvetica, sans-serif" size="2">.</font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding: 5px; text-align: center;" width="0">'
	cHTML += '						<em style="color: rgb(102, 102, 102); font-family: Arial, Helvetica, sans-serif; font-size: small;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
	
	For nI := 1 To Len( aSend )
		cMail := aSend[ nI, 3 ]
		If .NOT. Empty( cMail )
			cHTML_Aux := StrTran( cHTML, '__PREZADO__',  RTrim( aSend[ nI, 2 ] ) )
			FSSendMail( cMail, 'Análise da Solicitação de Despesa Nº'+cCR_NUM, cHTML_Aux, /*cAnexo*/ )	
		Endif
	Next nI 
Return

//-----------------------------------------------------------------------
// Rotina | A260CPF    | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se o participante está cadastrado como 
//        | fornecedor.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260CPF()
	Local lRet := .T.
	RD0->( dbSetOrder( 1 ) )
	RD0->( dbSeek( xFilial( 'RD0' ) + M->PAD_SOLICI ) )
	If .NOT. Empty( RD0->RD0_CIC )
		SA2->( dbSetOrder( 3 ) )
		If .NOT. SA2->( dbSeek( xFilial( 'SA2' ) + RD0->RD0_CIC ) )
	 		lRet := .F.
	 		MsgAlert(cFONT_V+'ATENÇÃO'+cFONT+'<br>O solicitante '+RTrim( RD0->RD0_NOME )+' não está cadastrado como FORNECEDOR, por favor, <br> providencie este cadastro para seguir '+;
	 		'com a solicitação de aprovação.'+cNOFONT,cCadastro)
		Endif
	Else
		lRet := .F.
		MsgAlert( cFONT_V + 'ATENÇÃO' + cFONT + '<br>O participante está sem CPF.' + cNOFONT, cCadastro )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A260CAR    | Autor | Robson Gonçalves     | Data | 09/12/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para cancelar aprovação caso possua título a pagar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A260CAR( cAlias, nRecNo, nOpc )
	Local aSay := {}
	Local aButton := {}
	Local aCompl := {}
	Local aSE2 := {}
	
	Local nI := 0
	Local nOpcao := 0
	
	Local cMsg := ''
	Local cPAD_NUMERO := ''
	Local cPAD_STATUS := PAD->PAD_STATUS
	Local cMV_260PREF := ''
	Local cMV_260TIPO := ''

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	
	If cPAD_STATUS $ '1|2'
		If PAD->PAD_COMPL == '0'
			
			cMV_260PREF := GetMv( 'MV_260PREF', .F. )
			
			cMV_260TIPO := GetMv( 'MV_260TIPO', .F. )
			
			If PAD->PAD_TPDESP == '1' //Adiantamento
				cMV_260TIPO := SubStr( cMV_260TIPO, 1, At( '#', cMV_260TIPO )-1 )
			Else
				cMV_260TIPO := SubStr( cMV_260TIPO, At( '#', cMV_260TIPO )+1 )
			Endif

			RD0->( dbSetOrder( 1 ) )
			RD0->( dbSeek( xFilial( 'RD0' ) + PAD->PAD_SOLICI ) )
			
			SA2->( dbSetOrder( 3 ) )
			SA2->( dbSeek( xFilial( 'SA2' ) + RD0->RD0_CIC ) )
			
			SE2->( dbSetOrder( 1 ) )
			SE2->( dbSeek( xFilial( 'SE2' ) + PadR( cMV_260PREF, Len( SE2->E2_PREFIXO ),' ' ) + ;
			                                  PadR( PAD->PAD_NUMERO, Len( SE2->E2_NUM ),' ') + ;
			                                  Space( Len( SE2->E2_PARCELA ) ) + ;
			                                  PadR( cMV_260TIPO, Len( SE2->E2_TIPO ),' ') + ;
			                                  SA2->A2_COD + SA2->A2_LOJA ) )
			
			// Verifica se o titulo nao esta em bordero.
			If !Empty( SE2->E2_NUMBOR )
				Help( " ", 1, "FA050BORD" )
				Return
			Endif
			
			// Verifica se o título já foi baixado.
			If SE2->E2_SALDO == 0
				Help(" ",1,"FA050BAIXA")
				Return 
			Endif
			
			// Verifica se o título já foi baixado.
			If !Empty( SE2->E2_BAIXA )
				Help( " ", 1, "FA050BAIXA" )
				Return
			Endif
			
			// Verifica se o título possui baixa parcial.
			If SE2->E2_VALOR != SE2->E2_SALDO
				Help( " ", 1, "BAIXAPARC" )
				Return
			Endif
			
			// Verifica se foi emitido cheque para este titulo.
			If SE2->E2_IMPCHEQ == "S"
				Help( " ", 1, "EXISTCHEQ" )
				Return
			Endif
			// Verifica se foi emitido cheque para um dos titulos de impostos.
			If Fa050VerImp()
				Help( " ", 1, "EXISTCHEQ" )
				Return
			Endif
	
			AAdd( aSay, 'Esta ação permite ao usuário cancelar a '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' da solicitação de despesa em questão.' )
			
			If cPAD_STATUS=='1'
				AAdd( aSay, 'Neste caso será verificado se o título a pagar não recebeu nenhum movimento.' )
				AAdd( aSay, 'Caso o título a pagar tenha algum movimento não será possível cancelar.' )
			Endif
			
			AAdd( aSay, '' )
			AAdd( aSay, '' )
			AAdd( aSay, '' )
			AAdd( aSay, 'Clique em OK para prosseguir.' )
			
			AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
			AAdd( aButton, { 22, .T., { || FechaBatch() } } )
			
			FormBatch( cCadastro, aSay, aButton )
			
			If nOpcao==1
			
				cMsg := 'Deseja realmente CANCELAR a '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' da solicitação de despesa?'
				
				If MsgYesNo( cMsg, cCadastro )
				
					cPAD_NUMERO := PAD->PAD_NUMERO
					
					If cPAD_STATUS == '1'
						AAdd( aSE2, { 'E2_FILIAL' , SE2->E2_FILIAL , '.T.' } )
						AAdd( aSE2, { 'E2_PREFIXO', SE2->E2_PREFIXO, '.T.' } )
						AAdd( aSE2, { 'E2_NUM'    , SE2->E2_NUM    , '.T.' } )
						AAdd( aSE2, { 'E2_PARCELA', SE2->E2_PARCELA, '.T.' } )
						AAdd( aSE2, { 'E2_TIPO'   , SE2->E2_TIPO   , '.T.' } )
						AAdd( aSE2, { 'E2_FORNECE', SE2->E2_FORNECE, '.T.' } )
						AAdd( aSE2, { 'E2_LOJA'   , SE2->E2_LOJA   , '.T.' } )
						
						FWMsgRun( , {|| MsExecAuto( {|a, b, c| FINA050( a, b, c) },aSE2,,5) }, ,'Excluíndo título a pagar...' )
						
						If lMsErroAuto
							MsgAlert(cFONT_V+'ATENÇÃO!'+cFONT+'<br>Não foi possível excluir o título a pagar vinculado com a solicitação de despesas.'+cNOFONT,cCadastro)
							MostraErro()
						Else
						
							SCR->( dbSetOrder( 1 ) )
							SCR->( dbSeek( xFilial( 'SCR' ) + cTP_DOC + PadR( cPAD_NUMERO, Space( Len( SCR->CR_NUM ) ), ' ' ) ) )
							While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. SCR->CR_TIPO == cTP_DOC .AND. RTrim( SCR->CR_NUM ) == cPAD_NUMERO
								SCR->( RecLock( 'SCR', .F. ) )
								SCR->( dbDelete() )
								SCR->( MsUnLock() )
								SCR->( dbSkip() )
							End
							
							While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
								AAdd(aCompl,PAD->(RecNo()))
								PAD->(dbSkip())
							End
							
							If Len( aCompl ) > 1
								MsgInfo('Foi identificado que há complemento(s) de solicitação de despesas, por isso este(s) complemento(s) será(ão) apagado(s).',cCadastro)
							Endif
							
							For nI := 1 To Len(aCompl)
								PAD->(dbGoTo(aCompl[nI]))
								PAD->(RecLock('PAD',.F.))
								If nI == 1
									PAD->PAD_STATUS := '0'
									PAD->PAD_USUAPR := ''
									PAD->PAD_DTAPR  := Ctod('  /  /  ')
								Else
									PAD->(dbDelete())
								Endif
								PAD->(MsUnLock())
							Next nI
							
							MsgInfo('Operação de cancelamento da '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' realizada com sucesso.',cCadastro)
							PAD->(dbSeek(xFilial('PAD')+cPAD_NUMERO))
						Endif
					Else
						PAD->(RecLock('PAD',.F.))
						PAD->PAD_STATUS := '0'
						PAD->PAD_MOTREJ := ''
						PAD->PAD_USUREJ := ''
						PAD->PAD_DTREJ  := Ctod('  /  /  ')
						PAD->(MsUnLock())
						
						MsgInfo('Operação de cancelamento da '+Iif(cPAD_STATUS=='1','aprovação','rejeição')+' realizada com sucesso.',cCadastro)
					Endif
				Endif
			Endif
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Não é possível cancelar ações que não seja aprovação ou rejeição de solicitação de despesa.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | UPD260     | Autor | Robson Gonçalves     | Data | 07.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD260()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U260Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U260Ini    | Autor | Robson Gonçalves     | Data | 07.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U260Ini()
	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	aSX7 := {}
	aSXB := {}
	aHelp := {}

	// PAD - Cadastro de solicitação de despesa.
	AAdd(aSX2,{"PAD","","Solicitacao de Despesas","Solicitacao de Despesas","Solicitacao de Despesas","E","",})

	AAdd(aSX3,{"PAD","01","PAD_FILIAL","C", 2,0 ,"Filial"       ,"Sucursal"    ,"Branch","Filial do Sistema","Sucursal","Branch of the System","@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","",""})
	AAdd(aSX3,{"PAD","02","PAD_NUMERO","C", 6,0 ,"Nº Despesa"   ,"Nº Despesa"  ,"Nº Despesa","Numero da despesa","Numero da despesa","Numero da despesa","","","€€€€€€€€€€€€€€ ","GetSXENum('PAD','PAD_NUMERO')","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","03","PAD_COMPL" ,"C", 1,0 ,"Complemento"  ,"Complemento" ,"Complemento","Complemento de despesa","Complemento de despesa","Complemento de despesa","","","€€€€€€€€€€€€€€ ","'00'","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","04","PAD_EMISSA","D", 8,0 ,"Emissao"      ,"Emissao"     ,"Emissao","Data de emissao","Data de emissao","Data de emissao","","","€€€€€€€€€€€€€€ ","DDATABASE","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","05","PAD_HORA"  ,"C", 8,0 ,"Hora"         ,"Hora"        ,"Hora","Hora da emissao da desp.","Hora da emissao da desp.","Hora da emissao da desp.","99:99:99","","€€€€€€€€€€€€€€ ","Time()","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","06","PAD_CC"    ,"C", 9,0 ,"C.Custo"      ,"C.Custo"     ,"C.Custo","Centro de Custo","Centro de Custo","Centro de Custo","@!","","€€€€€€€€€€€€€€ ","","CTT",0,"þÀ","","","U","N","A","R","€","Vazio().Or.CTB105CC()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","07","PAD_CONTA" ,"C",20,0 ,"C.Contab."    ,"C.Contab."   ,"C.Contab.","Conta Contabil","Conta Contabil","Conta Contabil","@!","","€€€€€€€€€€€€€€ ","","CT1",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105Cta()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","08","PAD_ITCTB" ,"C", 9,0 ,"C.Resulta"    ,"C.Resulta"   ,"C.Resulta","Centro de Resultado","Centro de Resultado","Centro de Resultado"  ,"@!","","€€€€€€€€€€€€€€ ","","CTD",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105Item()","","","","","","","","","","","","","N","N","",""})	
	AAdd(aSX3,{"PAD","09","PAD_CLVL"  ,"C", 9,0 ,"Projetos"     ,"Projetos"    ,"Projetos" ,"Projetos - Classe Vlr","Projetos - Classe Vlr","Projetos - Classe Vlr","@!","","€€€€€€€€€€€€€€ ","","CTH",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105ClVl()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","10","PAD_SOLICI","C", 6,0 ,"Solicitante"  ,"Solicitante" ,"Solicitante","Codigo do solicitante","Codigo do solicitante","Codigo do solicitante","@!","","€€€€€€€€€€€€€€ ","","RD0",0,"þÀ","","S","U","S","A","R","€","ExistCpo('RD0',M->PAD_SOLICI).AND.U_A260CPF()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","11","PAD_NOMSOL","C",30,0 ,"Nom.Solicit." ,"Nom.Solicit.","Nom.Solicit.","Nome do solicitante","Nome do solicitante","Nome do solicitante","@!","","€€€€€€€€€€€€€€ ","Iif(INCLUI,Space(Len(RD0->RD0_NOME)),Posicione('RD0',1,xFilial('RD0')+PAD->PAD_SOLICI,'RD0_NOME'))","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","12","PAD_PERDE" ,"D", 8,0 ,"Periodo de"   ,"Periodo de"  ,"Periodo de","Periodo inicial","Periodo inicial","Periodo inicial","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","13","PAD_PERATE","D", 8,0 ,"Periodo ate"  ,"Periodo ate" ,"Periodo ate","Periodo final","Periodo final","Periodo final","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","€","Iif((M->PAD_PERATE>=M->PAD_PERDE),.T.,(MsgAlert('Periodo inicial deve ser menor que final.'),.F.))","","","","","","","","","","","","","N","N","",""})	
	AAdd(aSX3,{"PAD","14","PAD_UF"    ,"C", 2,0 ,"UF"           ,"UF"          ,"UF"          ,"Unidade Federativa"     ,"Unidade Federativa"     ,"Unidade Federativa"     ,"","","€€€€€€€€€€€€€€ ","","12",0,"þÀ","","","U","S","A","R","€","ExistCpo('SX5','12'+M->PAD_UF)","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","15","PAD_MOT"   ,"C",60,0 ,"Motivo"       ,"Motivo"      ,"Motivo"      ,"Motivo da despesa"      ,"Motivo da despesa"      ,"Motivo da despesa"      ,"","","€€€€€€€€€€€€€€ ","",""  ,0,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","16","PAD_MOTIVO","M",10,0 ,"Descr.Motivo" ,"Descr.Motivo","Descr.Motivo","Descr.Motivo da despesa","Descr.Motivo da despesa","Descr.Motivo da despesa","","","€€€€€€€€€€€€€€ ","",""  ,0,"þÀ","","","U","N","A","R","" ,"","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","17","PAD_VLRADI","N",12,2 ,"Vlr. Adiant." ,"Vlr. Adiant.","Vlr. Adiant.","Valor do adiantamento","Valor do adiantamento","Valor do adiantamento","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","18","PAD_PREVPG","D", 8,0 ,"Prev.Pagto","Prev.Pagto","Prev.Pagto","Previsao de pagamento","Previsao de pagamento","Previsao de pagamento" ,"","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","19","PAD_OUTMOE","N",12,2 ,"Qtd. Outra $" ,"Qtd. Outra $","Qtd. Outra $","Quantidade em outra moeda","Quantidade em outra moeda","Quantidade em outra moeda","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","20","PAD_MOEDA" ,"C", 1,0 ,"Qual moeda?"  ,"Qual moeda?" ,"Qual moeda?","Em qual moeda?","Em qual moeda?","Em qual moeda?","","","€€€€€€€€€€€€€€ ","'1'","",0,"þÀ","","","U","N","A","R","","Pertence('012345')","0=Nenhuma;1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","0=Nenhuma;1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","0=Nenhuma;1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","21","PAD_HOTEL" ,"C", 1,0 ,"Reserv.Hotel" ,"Reserv.Hotel","Reserv.Hotel","Reserva hotel","Reserva hotel","Reserva hotel","","","€€€€€€€€€€€€€€ ","'2'","",0,"þÀ","","","U","N","A","R","","Pertence('12')","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","22","PAD_PASSAG","C", 1,0 ,"Passag.Aerea" ,"Passag.Aerea","Passag.Aerea","Passagem aerea","Passagem aerea","Passagem aerea","","","€€€€€€€€€€€€€€ ","'2'","",0,"þÀ","","","U","N","A","R","","Pertence('12')","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","23","PAD_ALUVEI","C", 1,0 ,"Alug.Veiculo" ,"Alug.Veiculo","Alug.Veiculo","Aluguel de veiculo","Aluguel de veiculo","Aluguel de veiculo","","","€€€€€€€€€€€€€€ ","'2'","",0,"þÀ","","","U","N","A","R","","Pertence('12')","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","24","PAD_STATUS","C", 1,0 ,"Status"       ,"Status"      ,"Status","Status da solicitacao","Status da solicitacao","Status da solicitacao","@!","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","0=Solicitacao;1=Aprovado;2=Rejeitado;3=Despesas digitadas;4=Despesas aprovadas","0=Solicitacao;1=Aprovado;2=Rejeitado;3=Despesas digitadas;4=Despesas aprovadas","0=Solicitacao;1=Aprovado;2=Rejeitado;3=Despesas digitadas;4=Despesas aprovadas","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","25","PAD_MOTREJ","M",10,0 ,"Motivo Rej."  ,"Motivo Rej." ,"Motivo Rej.","Motivo da rejeicao","Motivo da rejeicao","Motivo da rejeicao","@!","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","26","PAD_OPERAD","C", 6,0 ,"Operador"     ,"Operador"    ,"Operador","Codigo do operador","Codigo do operador","Codigo do operador","@!","","€€€€€€€€€€€€€€ ","RetCodUsr()","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","27","PAD_NOMOPE","C", 30,0,"Nome Operad.","Nome Operad.","Nome Operad.","Nome do operador","Nome do operador","Nome do operador","@!","","€€€€€€€€€€€€€€ ","IIF(INCLUI,UsrFullName(RetCodUsr()),UsrFullName(PAD->PAD_OPERAD))","",0,"þÀ","","","U","S","V","V","","","","","","","","UsrFullName(PAD->PAD_OPERAD)","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","28","PAD_ULTDIG","D", 8,0 ,"Ult.Digitac." ,"Ult.Digitac.","Ult.Digitac.","Data ultima digitacao","Data ultima digitacao","Data ultima digitacao","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","29","PAD_USUAPR","C", 6,0 ,"Aprov.Solic." ,"Aprov.Solic.","Aprov.Solic.","Codigo do aprov. solicit.","Codigo do aprov. solicit.","Codigo do aprov. solicit.","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","30","PAD_NOMAPR","C", 25,0,"Nome Ap.Sol.","Nome Ap.Sol.","Nome Ap.Sol.","Nome do aprov. solicit."  ,"Nome do aprov. solicit."  ,"Nome do aprov. solicit."  ,""  ,"","€€€€€€€€€€€€€€ ","IIF(INCLUI,UsrRetName(RetCodUsr()),UsrRetName(PAD->PAD_USUAPR))","",0,"þÀ","","","U","S","V","V","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","31","PAD_DTAPR" ,"D", 8,0 ,"Data Aprov."  ,"Data Aprov." ,"Data Aprov." ,"Data da aprovação"        ,"Data da aprovação"        ,"Data da aprovação"        ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","32","PAD_DTAPDE","D", 8,0 ,"Dt.Apr.Desp." ,"Dt.Apr.Desp.","Dt.Apr.Desp.","Dt. aprov. das despesas"  ,"Dt. aprov. das despesas"  ,"Dt. aprov. das despesas"  ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","33","PAD_USUREJ","C", 6,0 ,"Rej.Solic."   ,"Rej.Solic."   ,"Rej.Solic."   ,"Codigo de quem rejeitou","Codigo de quem rejeitou","Codigo de quem rejeitou","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","34","PAD_NOMREJ","C", 25,0,"Nome Rej.Sol.","Nome Rej.Sol.","Nome Rej.Sol.","Nome de quem rejeitou"  ,"Nome de quem rejeitou"  ,"Nome de quem rejeitou"  ,""  ,"","€€€€€€€€€€€€€€ ","IIF(INCLUI,UsrRetName(RetCodUsr()),UsrRetName(PAD->PAD_USUREJ))","",0,"þÀ","","","U","S","V","V","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","35","PAD_DTREJ" ,"D", 8,0 ,"Data Rejeicao","Data Rejeicao","Data Rejeicao","Data da rejeicao"       ,"Data da rejeicao"       ,"Data da rejeicao"       ,""  ,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","36","PAD_VLPAAE","N",12,2 ,"Vl.Pas.Aerea" ,"Vl.Pas.Aerea","Vl.Pas.Aerea","Valor passagem aerea","Valor passagem aerea","Valor passagem aerea","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","37","PAD_VLAPAE","N",12,2 ,"Vl.Alt.P.Aer" ,"Vl.Alt.P.Aer","Vl.Alt.P.Aer","Valor alt.passagem aerea","Valor alt.passagem aerea","Valor alt.passagem aerea","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","38","PAD_VLHOSP","N",12,2 ,"Vlr.Hospedag" ,"Vlr.Hospedag","Vlr.Hospedag","Valor da hospedagem","Valor da hospedagem","Valor da hospedagem","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","39","PAD_VLALVE","N",12,2 ,"Vl.Alug.Veíc" ,"Vl.Alug.Veíc","Vl.Alug.Veíc","Valor aluguel de veiculo","Valor aluguel de veiculo","Valor aluguel de veiculo","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Positivo()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","40","PAD_PINIRE","D", 8,0 ,"Per.Ini.Real","Per.Ini.Real","Per.Ini.Real","Periodo inicial realizado","Periodo inicial realizado","Periodo inicial realizado","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","41","PAD_PFIMRE","D", 8,0 ,"Per.Fim Real","Per.Fim Real","Per.Fim Real","Periodo final realizado"  ,"Periodo final realizado"  ,"Periodo final realizado"  ,"","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","Iif((M->PAD_PFIMRE>=M->PAD_PINIRE),.T.,(MsgAlert('Periodo inicial deve ser menor que final.'),.F.))","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","42","PAD_BANCO" ,"C",3,0 ,"Banco","Banco","Banco","Codigo do banco","Codigo do banco","Codigo do banco","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","43","PAD_AGENCI","C",5,0 ,"Agencia","Agencia","Agencia","Agencia do banco","Agencia do banco","Agencia do banco","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","44","PAD_DVAGEN","C",1,0 ,"DV. Agencia","DV. Agencia","DV. Agencia","Digito verificador agenc.","Digito verificador agenc.","Digito verificador agenc.","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","45","PAD_NUMCTA","C",10,0,"Cta.Corrente","Cta.Corrente","Cta.Corrente","Conta corrente","Conta corrente","Conta corrente","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","46","PAD_DVCTA" ,"C",1,0 ,"DV. da conta","DV. da conta","DV. da conta","Digito Verif. da Conta","Digito Verif. da Conta","Digito Verif. da Conta","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAD","47","PAD_TPDESP","C", 1,0 ,"Tp. despesa?","Tp. despesa?","","Tipo de despesa?","Tipo de despesa?","Tipo de despesa?","","","€€€€€€€€€€€€€€ ","' '","",0,"þÀ","","","U","N","A","R","€","Vazio().OR.Pertence('12')","1=Adiantamento;2=Reembolso","1=Adiantamento;2=Reembolso","1=Adiantamento;2=Reembolso","","","","","","","","","","N","N","",""})
	
	AAdd(aHelp,{"PAD_FILIAL","Código da filial no sistema."})
	AAdd(aHelp,{"PAD_NUMERO","Número da despesas."})
	AAdd(aHelp,{"PAD_COMPL" ,"Complemento de solicitação de despesa."})
	AAdd(aHelp,{"PAD_EMISSA","Data de emissão da despesa."})
	AAdd(aHelp,{"PAD_HORA"  ,"Hora da emissao da despesa."})
	AAdd(aHelp,{"PAD_CC"    ,"Departamento/Centro de Custo."})
	AAdd(aHelp,{"PAD_CONTA" ,"Código da conta contábil."})
	AAdd(aHelp,{"PAD_ITCTB" ,"Código do item contábil."})
	AAdd(aHelp,{"PAD_CLVL"  ,"Código do projeto/classe de valor."})
	AAdd(aHelp,{"PAD_SOLICI","Código do solicitante."})
	AAdd(aHelp,{"PAD_NOMSOL","Nome do solicitante."})
	AAdd(aHelp,{"PAD_PERDE" ,"Periodo inicial."})
	AAdd(aHelp,{"PAD_PERATE","Periodo final."})
	AAdd(aHelp,{"PAD_UF"    ,"Qual é a Unidade Federativa, estado brasileiro."})
	AAdd(aHelp,{"PAD_MOT"   ,"Qual é o motivo da despesa."})
	AAdd(aHelp,{"PAD_MOTIVO","Qual é a descrição do motivo da despesa."})
	AAdd(aHelp,{"PAD_VLRADI","Valor do adiantamento."})
	AAdd(aHelp,{"PAD_PREVPG","Data da previsão de pagamento."})
	AAdd(aHelp,{"PAD_OUTMOE","Quantidade de dinheiro em outra moeda."})
	AAdd(aHelp,{"PAD_MOEDA" ,"Em qual moeda está sendo fornecida?"})
	AAdd(aHelp,{"PAD_HOTEL" ,"Haverá reserva de hotel?"})
	AAdd(aHelp,{"PAD_PASSAG","Haverá compra de passagem aérea?"})
	AAdd(aHelp,{"PAD_ALUVEI","Haverá aluguel de veículo?"})
	AAdd(aHelp,{"PAD_STATUS","Status da solicitação, podendo ser:0=Solicitacao; 1=Aprovado; 2=Rejeitado; 3=Despesas digitadas; 4=Despesas aprovadas"})
	AAdd(aHelp,{"PAD_MOTREJ","Texto informativo com o motivo da rejeição."})
	AAdd(aHelp,{"PAD_OPERAD","Código do operador que digitou a solicitação."})
	AAdd(aHelp,{"PAD_NOMOPE","Nome do operador que digitou a solicitação de despesa."})
	AAdd(aHelp,{"PAD_ULTDIG","Data da última digitação efetuada."})
	AAdd(aHelp,{"PAD_USUAPR","Codigo do usuario que aprovou ou rejeitou a solicitação."})
	AAdd(aHelp,{"PAD_NOMAPR","Nome do usuario que aprovou ou rejeitou a solicitação."})
	AAdd(aHelp,{"PAD_DTAPR" ,"Data da aprovação ou rejeição da solicitação de despesas."})
	AAdd(aHelp,{"PAD_DTAPDE","Data da aprovação das despesas digitadas."})
	AAdd(aHelp,{"PAD_USUREJ","Codigo do usuario que rejeitou a solicitação."})
	AAdd(aHelp,{"PAD_NOMREJ","Nome do usuario que rejeitou a solicitação."})
	AAdd(aHelp,{"PAD_DTREJ" ,"Data da rejeição da solicitação de despesas."})
	AAdd(aHelp,{"PAD_VLPAAE","Valor da passagem aérea."})
	AAdd(aHelp,{"PAD_VLAPAE","Valor de alteração da passagem aérea."})
	AAdd(aHelp,{"PAD_VLHOSP","Valor da hospedagem."})
	AAdd(aHelp,{"PAD_VLALVE","Valor do aluguel de veículo."})
	AAdd(aHelp,{"PAD_PINIRE","Período inicial realizado."})
	AAdd(aHelp,{"PAD_PFIMRE","Período final realizado."})
	AAdd(aHelp,{"PAD_BANCO","Código do banco,"})
	AAdd(aHelp,{"PAD_AGENCI","Número da agência bancária."})
	AAdd(aHelp,{"PAD_DVAGEN","Digito verificador da agência bancária."})
	AAdd(aHelp,{"PAD_NUMCTA","Número da conta corrente no banco."})
	AAdd(aHelp,{"PAD_DVCTA","Digito verificado da conta corrente no banco."})
	AAdd(aHelp,{"PAD_TPDESP","Informe o tipo de despesa podendo ser Adiantamento ou Reembolso."})
	
	AAdd(aSIX,{"PAD","1","PAD_FILIAL+PAD_NUMERO+PAD_COMPL","Nº Despesa + Complemento","Nº Despesa + Complemento","Nº Despesa + Complemento","U","S"})
	AAdd(aSIX,{"PAD","2","PAD_FILIAL+PAD_NOMSOL+PAD_NUMERO+PAD_COMPL","Nome do Solicitante + Nº Despesa + Complemento","Nome do Solicitante + Nº Despesa + Complemento","Nome do Solicitante + Nº Despesa + Complemento","U","S"})
	AAdd(aSIX,{"PAD","3","PAD_FILIAL+Dtos(PAD_PERDE)+Dtos(PAD_PERATE)","Periodo de + Periodo ate","Periodo de + Periodo ate","Periodo de + Periodo ate","U","S"})
	
	AAdd(aSX7,{"PAD_SOLICI","001","RD0->RD0_NOME"  ,"PAD_NOMSOL","P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	AAdd(aSX7,{"PAD_SOLICI","002","RD0->RD0_BANCO" ,"PAD_BANCO" ,"P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	AAdd(aSX7,{"PAD_SOLICI","003","RD0->RD0_AGENCI","PAD_AGENCI","P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	AAdd(aSX7,{"PAD_SOLICI","004","RD0->RD0_DVAGEN","PAD_DVAGEN","P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	AAdd(aSX7,{"PAD_SOLICI","005","RD0->RD0_NUMCTA","PAD_NUMCTA","P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	AAdd(aSX7,{"PAD_SOLICI","006","RD0->RD0_DVCTA" ,"PAD_DVCTA" ,"P","S","RD0",1,"xFilial('RD0')+M->PAD_SOLICI","","U"})
	
	AAdd(aSXB,{"PAD","1","01","DB","Solicit. de Despesa","Solicit. de Despesa","Solicit. de Despesa","PAD",""})
	AAdd(aSXB,{"PAD","2","01","01","Nº despesa + Complem","Nº despesa + Complem","Nº despesa + Complem","",""})
	AAdd(aSXB,{"PAD","4","01","01","Nº Despesa","Nº Despesa","Nº Despesa","PAD_NUMERO",""})
	AAdd(aSXB,{"PAD","4","01","02","Complemento","Complemento","Complemento","PAD_COMPL",""})
	AAdd(aSXB,{"PAD","4","01","03","Emissao","Emissao","Emissao","PAD_EMISSA",""})
	AAdd(aSXB,{"PAD","4","01","04","Periodo de","Periodo de","Periodo de","PAD_PERDE",""})
	AAdd(aSXB,{"PAD","4","01","05","Periodo ate","Periodo ate","Periodo ate","PAD_PERATE",""})
	AAdd(aSXB,{"PAD","5","01","","","","","PAD->PAD_NUMERO",""})	

	// PAE - Relação das Despesas
	AAdd(aSX2,{"PAE","","Relacao de Despesas","Relacao de Despesas","Relacao de Despesas","E",""})
		
	AAdd(aSX3,{"PAE","01","PAE_FILIAL","C", 2,0,"Filial","Filial","Filial","Filial do Sistema","Filial do Sistema","Filial do Sistema","@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","V","R","","","","","","","","","033","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","02","PAE_NUMERO","C", 6,0,"Nº Despesa","Nº Despesa","Nº Despesa","Numero da despesa","Numero da despesa","Numero da despesa","@!","","€€€€€€€€€€€€€€€","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","03","PAE_ITEM"  ,"C", 3,0,"Item","Item","Item","Item da despesa","Item da despesa","Item da despesa","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","04","PAE_DATA"  ,"D", 8,0,"Data","Data","Data","Data da despesa","Data da despesa","Data da despesa","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","€","U_A280VldDt()","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","05","PAE_TPDESP","C", 6,0,"Cod. Despesa","Cod. Despesa","Cod. Despesa","Codigo da despesa","Codigo da despesa","Codigo da despesa","@!","","€€€€€€€€€€€€€€ ","","PAF",0,"þÀ","","S","U","S","A","R","€","U_A280StrZero() .And. ExistCpo('PAF')","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","06","PAE_DESDES","C",40,0,"Tipo Despesa","Tipo Despesa","Tipo Despesa","Tipo da despesa","Tipo da despesa","Tipo da despesa","@!","","€€€€€€€€€€€€€€ ","Iif(INCLUI,Space(Len(PAF->PAF_DESCR)),Posicione('PAF',1,xFilial('PAF')+PAE->PAE_TPDESP,'PAF_DESCR'))","",0,"þÀ","","","U","S","V","V","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","07","PAE_DESCRI","C",30,0,"Descri.Desp.","Descri.Desp.","Descri.Desp.","Descricao da despesa","Descricao da despesa","Descricao da despesa","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","08","PAE_COMPL" ,"M",10,0,"Complemento","Complemento","Complemento","Complemento","Complemento","Complemento","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","09","PAE_QTDE"  ,"N",12,2,"Quantidade","Quantidade","Quantidade","Quantidade","Quantidade","Quantidade","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","S","U","S","A","R","","Positivo()","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","10","PAE_UNIT"  ,"N",12,2,"Unitario","Unitario","Unitario","Valor unitario","Valor unitario","Valor unitario","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","S","U","S","A","R","","Positivo()","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","11","PAE_TOTAL" ,"N",12,2,"Total","Total","Total","Valor total","Valor total","Valor total","@E 999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","12","PAE_MOEDA" ,"C", 1,0,"Moeda?","Moeda?","Moeda?","Identificacao da moeda","Identificacao da moeda","Identificacao da moeda","","","€€€€€€€€€€€€€€ ","'1'","",0,"þÀ","","","U","N","A","R","","Pertence('12345')","1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","1=Real;2=Dolar;3=Euro;4=Peso Arg.;5=Peso Chileno","","","","","","","","","","N","N","",""})
   AAdd(aSX3,{"PAE","13","PAE_CC"    ,"C", 9,0,"C.Custo","C.Custo","C.Custo","Centro de Custo","Centro de Custo","Centro de Custo","@!","","€€€€€€€€€€€€€€ ","","CTT",0,"þÀ","","","U","N","A","R","€","Vazio().Or.CTB105CC()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAE","14","PAE_CONTA" ,"C",20,0,"C.Contab.","C.Contab.","C.Contab.","Conta Contabil","Conta Contabil","Conta Contabil","@!","","€€€€€€€€€€€€€€ ","","CT1",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105Cta()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAE","15","PAE_ITCTB" ,"C", 9,0,"C.Resulta","C.Resulta","C.Resulta","Centro de Resultado","Centro de Resultado","Centro de Resultado"  ,"@!","","€€€€€€€€€€€€€€ ","","CTD",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105Item()","","","","","","","","","","","","","N","N","",""})	
	AAdd(aSX3,{"PAE","16","PAE_CLVL"  ,"C", 9,0,"Projetos" ,"Projetos" ,"Projetos" ,"Projetos - Classe Vlr","Projetos - Classe Vlr","Projetos - Classe Vlr","@!","","€€€€€€€€€€€€€€ ","","CTH",0,"þÀ","","","U","N","A","R","","Vazio().Or.Ctb105ClVl()","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAE","17","PAE_OUTPRJ","C",20,0,"Outros Proj." ,"Outros Proj." ,"Outros Proj." ,"Descricao outros projetos","Descricao outros projetos","Descricao outros projetos","@!","","€€€€€€€€€€€€€€ ","","CTH",0,"","","","U","N","A","R","","","","","","","","","","","","","","","N","N","",""})
	AAdd(aSX3,{"PAE","18","PAE_NROPOR","C", 6,0,"Num. Oport.","Num. Oport.","Num. Oport.","Numero da oportunidade","Numero da oportunidade","Numero da oportunidade","@!","","€€€€€€€€€€€€€€ ","","AD1",0,"þÀ","","","U","S","A","R","","Vazio().Or.ExistCpo('AD1')","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","19","PAE_TRJORI","M",10,0,"Traj.Origem","Traj.Origem","Traj.Origem","Trajeto origem","Trajeto origem","Trajeto origem","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","20","PAE_TRJDES","M",10,0,"Traj.Destino","Traj.Destino","Traj.Destino","Trajeto destino","Trajeto destino","Trajeto destino","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","21","PAE_CLIENT","C", 6,0,"Cod.Cliente","Cod.Cliente","Cod.Cliente","Codigo do cliente","Codigo do cliente","Codigo do cliente","@!","","€€€€€€€€€€€€€€ ","","SA1",0,"þÀ","","S","U","S","A","R","","Vazio().Or.ExistCpo('SA1')","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","22","PAE_LOJA"  ,"C", 2,0,"Loja","Loja","Loja","Loja do cliente","Loja do cliente","Loja do cliente","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","23","PAE_NOME"  ,"C",40,0,"Nome","Nome","Nome","Nome do cliente","Nome do cliente","Nome do cliente","@!","","€€€€€€€€€€€€€€ ","Iif(INCLUI,Space(Len(SA1->A1_NOME)),Posicione('SA1',1,xFilial('SA1')+PAE->(PAE_CLIENT+PAE_LOJA),'A1_NOME'))","",0,"þA","","","U","S","V","V","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","24","PAE_BAIRRO","C",30,0,"Bairro","Bairro","Bairro","Bairro","Bairro","Bairro","@!","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","25","PAE_CIDADE","C",30,0,"Cidade","Cidade","Cidade","Cidade","Cidade","Cidade","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","26","PAE_NUMOS" ,"C",10,0,"Num. O.S.","Num. O.S.","Num. O.S.","Numero ordem de servico","Numero ordem de servico","Numero ordem de servico","@!","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","27","PAE_OBSERV","M",10,0,"Observacao","Observacao","Observacao","Observacao","Observacao","Observacao","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","28","PAE_BOLVOU","C", 6,0,"Boleto/Vouch","Boleto/Vouch","Boleto/Vouch","ID Boleto ou Voucher","ID Boleto ou Voucher","ID Boleto ou Voucher","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","29","PAE_SETOR" ,"C",40,0,"Setor","Setor","Setor","Setor","Setor","Setor","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","30","PAE_KMINI" ,"N", 9,0,"Km Inicial","Km Inicial","Km Inicial","KM Inicial","KM Inicial","KM Inicial","@<E 999,999,999","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","S","U","S","A","R","","Positivo()","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","31","PAE_KMFIM" ,"N", 9,0,"KM Fim","KM Fim","KM Fim","KM Fim","KM Fim","KM Fim","@<E 999,999,999","","€€€€€€€€€€€€€€ ","","",0,"þA","","S","U","S","A","R","","Positivo().And.U_A280KM()","","","","","","","","","","","","N","N","N","",""})
	AAdd(aSX3,{"PAE","32","PAE_KMTOT" ,"N", 9,0,"KM Total","KM Total","KM Total","KM Total","KM Total","KM Total","@E 999,999,999","","€€€€€€€€€€€€€€ ","","",0,"þA","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","",""})
	
	AAdd(aHelp,{"PAE_FILIAL","Código da filial no sistema."})
	AAdd(aHelp,{"PAE_NUMERO","Número da solicitação de despesa relacionada."})
	AAdd(aHelp,{"PAE_ITEM"  ,"Item sequencial da despesa."})
	AAdd(aHelp,{"PAE_DATA"  ,"Data do consumo da despesa."})
	AAdd(aHelp,{"PAE_TPDESP","Código do tipo da despesa com determinação de poder ser reembolsável ou não."})
	AAdd(aHelp,{"PAE_DESDES","Descrição do tipo da despesa."})
	AAdd(aHelp,{"PAE_DESCRI","Descrição livre ou adicional para a despesa."})
	AAdd(aHelp,{"PAE_COMPL" ,"Complemento/justificativa da descrição da despesas"})
	AAdd(aHelp,{"PAE_QTDE"  ,"Quantidade consumida da despesa."})
	AAdd(aHelp,{"PAE_UNIT"  ,"Valor unitário da despesa."})
	AAdd(aHelp,{"PAE_TOTAL" ,"Valor total da despesa."})
	AAdd(aHelp,{"PAE_MOEDA" ,"Moeda de identificacao da declaração da despesa."})
	AAdd(aHelp,{"PAE_CC"    ,"Código do centro de custo."})
	AAdd(aHelp,{"PAE_CONTA" ,"Código da conta contábil."})
	AAdd(aHelp,{"PAE_ITCTB" ,"Código do item contábil."})
	AAdd(aHelp,{"PAE_CLVL"  ,"Código da classe de valor ou do projeto da despesa."})
	AAdd(aHelp,{"PAE_OUTPRJ","Descrição de outros projetos."})
	AAdd(aHelp,{"PAE_NROPOR","Número da oportunidade da despesa."})
	AAdd(aHelp,{"PAE_TRJORI","Trajeto origem da despesa."})
	AAdd(aHelp,{"PAE_TRJDES","Trajeto destino da despesa."})
	AAdd(aHelp,{"PAE_CLIENT","Código do cliente."})
	AAdd(aHelp,{"PAE_LOJA"  ,"Loja do cliente."})
	AAdd(aHelp,{"PAE_NOME"  ,"Nome do cliente."})
	AAdd(aHelp,{"PAE_BAIRRO","Bairro de atendimento para a despesa."})
	AAdd(aHelp,{"PAE_CIDADE","Cidade do atendimento da despesa."})
	AAdd(aHelp,{"PAE_NUMOS" ,"Número da ordem de serviço da despesa."})
	AAdd(aHelp,{"PAE_OBSERV","Observação a ser descrita para a despesa."})
	AAdd(aHelp,{"PAE_BOLVOU","Id do boleto ou voucher da despesa."})
	AAdd(aHelp,{"PAE_SETOR" ,"Setor de atendimento da despesa."})
	AAdd(aHelp,{"PAE_KMINI" ,"Número do KM inicial para atendimento da despesa."})
	AAdd(aHelp,{"PAE_KMFIM" ,"Número do KM final para atendimento da despesa."})
	AAdd(aHelp,{"PAE_KMTOT" ,"Número do KM total para atendimento da despesa."})

	AAdd(aSIX,{"PAE","1","PAE_FILIAL+PAE_NUMERO+PAE_ITEM","Nº Despesa + Item","Nº Despesa","Nº Despesa","U","S"})
	AAdd(aSIX,{"PAE","2","PAE_FILIAL+PAE_TPDESP","Tipo de Despesa","Tipo de Despesa","Tipo de Despesa","U","S"})

	AAdd(aSX7,{"PAE_CLIENT","001","SA1->A1_NOME","PAE_NOME","P","S","SA1",1,"xFilial('SA1')+M->PAE_CLIENT","","U"})
	AAdd(aSX7,{"PAE_KMFIM" ,"001","M->PAE_KMFIM-M->PAE_KMINI","PAE_KMTOT","P","N","",0,"","","U"})
	AAdd(aSX7,{"PAE_KMINI" ,"001","M->PAE_KMFIM-M->PAE_KMINI","PAE_KMTOT","P","N","",0,"","","U"})
	AAdd(aSX7,{"PAE_QTDE"  ,"001","M->PAE_QTDE*M->PAE_UNIT","PAE_TOTAL","P","N","",0,"","","U"})
	AAdd(aSX7,{"PAE_TPDESP","001","PAF->PAF_DESCR","PAE_DESDES","P","S","PAF",1,"xFilial('PAF')+M->PAE_TPDESP","","U"})
	AAdd(aSX7,{"PAE_TPDESP","002","PAD->PAD_CC"   ,"PAE_CC"    ,"P","S","PAD",1,"xFilial('PAD')+M->PAD_NUMERO","","U"})
	AAdd(aSX7,{"PAE_TPDESP","003","PAD->PAD_CONTA","PAE_CONTA" ,"P","S","PAD",1,"xFilial('PAD')+M->PAD_NUMERO","","U"})
	AAdd(aSX7,{"PAE_TPDESP","004","PAD->PAD_ITCTB","PAE_ITCTB" ,"P","S","PAD",1,"xFilial('PAD')+M->PAD_NUMERO","","U"})
	AAdd(aSX7,{"PAE_TPDESP","005","PAD->PAD_CLVL" ,"PAE_CLVL"  ,"P","S","PAD",1,"xFilial('PAD')+M->PAD_NUMERO","","U"})
	AAdd(aSX7,{"PAE_UNIT"  ,"001","M->PAE_QTDE*M->PAE_UNIT","PAE_TOTAL","P","N","",0,"","","U"})

	// PAF - Cadastro de Tipos de Despesas.
	AAdd(aSX2,{"PAF","","Tipos de despesas","Tipos de despesas","Tipos de despesas","E",""})
	
	AAdd(aSX3,{"PAF",NIL,"PAF_FILIAL","C", 2,0,"Filial"      ,"Sucursal"    ,"Branch"      ,"Filial do Sistema"        ,"Sucursal"                 ,"Branch of the System"     ,"@!",""              ,"€€€€€€€€€€€€€€€",""                             ,"",1,"þÀ","","","U","N","A","R","" ,"",""           ,""         ,""           ,"","","","033","","" ,"","","" ,"N","N","",""})
	AAdd(aSX3,{"PAF",NIL,"PAF_CODIGO","C", 6,0,"Codigo"      ,"Codigo"      ,"Codigo"      ,"Codigo do tipo de desp."  ,"Codigo do tipo de desp."  ,"Codigo do tipo de desp."  ,"@!",""              ,"€€€€€€€€€€€€€€ ","GetSXENum('PAF','PAF_CODIGO')","",0,"þÀ","","","U","S","V","R","" ,"",""           ,""         ,""           ,"","","",""   ,"","" ,"","","" ,"N","N","",""})
	AAdd(aSX3,{"PAF",NIL,"PAF_DESCR" ,"C",40,0,"Descricao"   ,"Descricao"   ,"Descricao"   ,"Descricao do tipo da desp","Descricao do tipo da desp","Descricao do tipo da desp","@!",""              ,"€€€€€€€€€€€€€€ ",""                             ,"",0,"þÀ","","","U","S","A","R","€","",""           ,""         ,""           ,"","","",""   ,"","" ,"","","" ,"N","N","",""})
	AAdd(aSX3,{"PAF",NIL,"PAF_REEMB" ,"C", 1,0,"Reembolsavel","Reembolsavel","Reembolsavel","Tipo reembolsabel"        ,"Tipo reembolsabel"        ,"Tipo reembolsabel"        ,"@!","Pertence('12')","€€€€€€€€€€€€€€ ",""                             ,"",0,"þÀ","","","U","S","A","R","€","","1=Sim;2=Nao","1=Si;2=No","1=Yes; 2=No","","","",""   ,"","" ,"","","" ,"N","N","",""})
	AAdd(aSX3,{"PAF",NIL,"PAF_MSBLQL","C", 1,0,"Bloqueado"   ,"Bloqueado"   ,"Bloqueado"   ,"Registro bloqueado"       ,"Registro bloqueado"       ,"Record Blocked"           ,""  ,"Pertence('12')","€€€€€€€€€€€€€€ ","'2'"                          ,"",1,"„€","","","U","S","A","R","" ,"","1=Sim;2=Nao","1=Si;2=No","1=Yes; 2=No","","","",""   ,"","S","","","N","N","N","",""})
	
	AAdd(aHelp,{"PAF_FILIAL","Código da filial do sistema."})
	AAdd(aHelp,{"PAF_CODIGO","Código do tipo de despesa."})
	AAdd(aHelp,{"PAF_DESCR" ,"Descrição do tipo da despesa."})
	AAdd(aHelp,{"PAF_REEMB" ,"Tipo de despesa é reembolsável? 1=Sim ou 2=Não."})
	AAdd(aHelp,{"PAF_MSBLQL","Registro bloqueado para uso. 1=Sim ou 2=Não."})

	AAdd(aSIX,{"PAF","1","PAF_FILIAL+PAF_CODIGO","Codigo","Codigo","Codigo","U","S"})
	
	AAdd(aSXB,{"PAF","1","01","DB","Tipos de despesas","Tipos de despesas","Tipos de despesas","PAF",""})
	AAdd(aSXB,{"PAF","2","01","01","Codigo","Codigo","Codigo","",""})
	AAdd(aSXB,{"PAF","4","01","01","Codigo","Codigo","Codigo","PAF_CODIGO",""})
	AAdd(aSXB,{"PAF","4","01","02","Descricao","Descricao","Descricao","PAF_DESCR",""})
	AAdd(aSXB,{"PAF","4","01","03","Reembolsavel","Reembolsavel","Reembolsavel","PAF_REEMB",""})
	AAdd(aSXB,{"PAF","5","01","","","","","PAF->PAF_CODIGO",""})
Return