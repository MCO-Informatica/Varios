//--------------------------------------------------------------------------------
// Rotina | CSFA640        | Autor | Robson Gonçalves            | Data | 16.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para aprovar os contratos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
#Include 'Protheus.ch'
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
User Function CSFA640()
	Local nOpc := 0
	Local cMV_640USR := 'MV_640USR'
	Local cCodUsr := RetCodUsr()
	Local cNameUsr := RTrim( UsrFullName( cCodUsr ) )
	Local aPar := {}
	Local aRet := {}
	Local cBkp := ''
	Local lPode := .T.
	Local lContinua := .T.
	Local cTitulo := 'Aprovação de contratos'
	
   If CN9->CN9_OKAY == '1'
   	MsgAlert('Este contrato deve obter aprovação/rejeição por meio de Workflow.',cTitulo)
   	Return
   Endif

	If CN9->CN9_OKAY == '2'
		MsgAlert(cFONTOK+'Contrato já aprovado.'+cNOFONT,'Aprovação de contratos',cTitulo)
		Return
	Endif
	
	If CN9->CN9_OKAY == '3'
		MsgAlert(cFONT+'Contrato reaprovado.'+cNOFONT,'Aprovação de contratos',cTitulo)
		Return
	Endif

	If .NOT. GetMv( cMV_640USR, .T. )
		CriarSX6( cMV_640USR, 'C', 'USUARIOS COM PERMISSÃO DE ACESSO PARA APROVAR/REJEITAR O CONTRATO. CSFA540.prw', '001666|000445|000908' )
	Endif		
	cMV_640USR := GetMv( cMV_640USR, .F. )
	
	If cCodUsr $ cMV_640USR
		cBkp := cCadastro
		cCadastro := 'Aprovar/Rejeitar Contrato'
		While lContinua
			nOpc := Aviso(cCadastro,'Qual ação quer fazer em relação a este contrato?',{'Aprovar','Rejeitar','Visualizar','Anexo(s)','Sair'},2,'Sr. '+cNameUsr)
			If nOpc == 1 .Or. nOpc == 2
				lPode := A640Pode( nOpc )
			Endif
			If lPode
				If nOpc == 1
					A640Grv( nOpc, cNameUsr )
					lContinua := .F.
				Elseif nOpc == 2
					AAdd(aPar,{11,'Qual o motivo da rejeição','','.T.','.T.',.T.})
					If ParamBox(aPar,'Registrar motivo da rejeição',@aRet,,,,,,,,.F.,.F.)
						A640Grv( nOpc, cNameUsr, aRet[ 1 ] )
					Else
						MsgAlert('Ação abandonada, nenhuma ação foi registrada',cCadastro)
						lContinua := .F.
					Endif
					lContinua := .F.
				Elseif nOpc == 3
					CN100Manut('CN9',CN9->( RecnO() ),2,.T.)
				Elseif nOpc == 4
					MsDocument('CN9',CN9->( RecnO() ),2,)
				Else
					lContinua := .F.
				Endif
			Else
				lContinua := .F.
			Endif
		End
		If cBkp <> ''
			cCadastro := cBkp
		Endif
	Else
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Usuário sem permissão de acesso para aprovar/rejeitar contratos.<br>Verifique o parâmetro MV_640USR',cCadastro)
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A640Pode       | Autor | Robson Gonçalves            | Data | 16.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para verificar se pode aprovar o contrato.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A640Pode( nOpc )
	Local lPode := .T.
	If .NOT. Empty( CN9->CN9_HISAPR )
		If 'aprovado' $ CN9->CN9_HISAPR
			lPode := .F.
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Contrato já aprovado conforme registro abaixo:<br>'+RTrim(CN9->CN9_HISAPR),cCadastro)
		Endif
	Endif
Return( lPode )

//--------------------------------------------------------------------------------
// Rotina | A640Grv        | Autor | Robson Gonçalves            | Data | 16.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para gravar a aprovação ou a rejeição.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A640Grv( nOpcao, cNomeUsr, cMotivo )
	Local cCN9_HISAPR := ''
	Local cAcao := Iif(nOpcao==1,'aprovado','rejeitado')
	cCN9_HISAPR := 'Contrato '+cAcao+' pelo usuário '+cNomeUsr+' em '+Dtoc(MsDate())+' as '+Time()+'.'
	If cMotivo <> NIL
		cCN9_HISAPR += CRLF + ' Motivo da rejeição: ' + RTrim( cMotivo )
	Endif
	CN9->( RecLock( 'CN9', .F. ) )
	If Empty( CN9->CN9_HISAPR )
		CN9->CN9_HISAPR := cCN9_HISAPR
	Else
		CN9->CN9_HISAPR := cCN9_HISAPR + CRLF + CN9->CN9_HISAPR
	Endif
	CN9->( MsUnLock() )
	MsgInfo(cFONTOK+'A gravação da '+Iif(nOpcao==1,'aprovação','rejeição')+' foi efetuada com sucesso.'+cNOFONT,cCadastro)
Return