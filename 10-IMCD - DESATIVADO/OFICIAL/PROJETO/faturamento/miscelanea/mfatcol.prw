#INCLUDE "PROTHEUS.CH"

// AVSX3
#define AV_TIPO    2
#define AV_TAMANHO 3  //Posicao no AVSX3()[] que retorna tamanho de campo
#define AV_DECIMAL 4
#define AV_TITULO  5
#define AV_PICTURE 6  //PICTURE DO CAMPO
#define AV_TRIGGER 10
#define AV_VALID   07

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATCOL   ºAutor  ³Ivan Morelatto Tore º Data ³  23/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informações de Coleta do Pedido                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATCOL

	Local nTpFil  := Aviso( "Tipo Filtro", "Informe o tipo do Filtro", { "C/Coleta", "S/Coleta", "Escolha Data", "Todos" } )
	Local cFiltra := ""
	Local lRoda		:= .f.
	Local oGet1
	Local dGet1 := Date()
	Local oSButton1
	Local lLoop	:= .t.
	Static oDlg
	Private bFilBrow  := {|| }
	Private cFiltro
	Private aIndexSC5 := {}

	SetKey(VK_F5, { || MsAguarde({|| LIMPA(),oMbObj := GetObjBrow(),oMbObj:REFRESH() },"Aguarde...","Limpando Filtro",.T.) })
	SetKey(VK_F6, { || MsAguarde({|| VOLTA(),oMbObj := GetObjBrow(),oMbObj:REFRESH() },"Aguarde...","Voltando Filtro",.T.) })

	//cFiltro  := "C5_TPFRETE == 'F' .AND. C5_X_CANC != 'C' .AND. C5_X_REP != 'R' .AND. C5_PVC == ' ' .AND. !Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) "
	//cFiltro  += ".And. Empty(C5_BLQ) .AND. DTOS(C5_XENTREG) >= '20100301'  .AND. (C5_LIBCRED == 'X' .OR. C5_CONDPAG == '100') .AND. !EMPTY(DTOS(C5_SOLCOL)) "

	cFiltro  := "C5_TPFRETE == 'F' .AND. C5_X_CANC != 'C' .AND. C5_X_REP != 'R' .AND. C5_PVC == ' ' .AND. !Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) "
	cFiltro  += ".And. Empty(C5_BLQ) .AND. DTOS(C5_XENTREG) >= '20170101'  "

	If nTPFil == 1
		cFiltro := cFiltro + " .AND. Empty(C5_NOTA) .AND. C5_REIMP = 1 "
	ElseIf nTPFil == 2
		cFiltro := cFiltro + " .AND. Empty(C5_NOTA) .AND. C5_REIMP = 0 "
	ElseIF nTPFil == 3
		DEFINE MSDIALOG oDlg TITLE "Escolha a Data" FROM 000, 000  TO 100, 200 COLORS 0, 16777215 PIXEL

		@ 017, 016 MSGET oGet1 VAR dGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
		DEFINE SBUTTON oSButton1 FROM 032, 031 TYPE 01 OF oDlg ENABLE action (lRoda:= .t., oDlg:END())

		ACTIVATE MSDIALOG oDlg CENTERED
		if lRoda
			cFiltro := cFiltro+ " .AND. Empty(C5_NOTA) .AND. DTOS(C5_SOLCOL) == '"+DTOS(dGet1)+"' "
		endif
	ElseIF nTPFil == 4
		cFiltro := cFiltro
	Endif
	bFilBrow := { || FilBrowse( "SC5", @aIndexSC5, @cFiltro ) }
	Eval( bFilBrow )

	MFATCOLA()

	EndFilBrw( "SC5", aIndexSC5 )

RETURN()

STATIC FUNCTION MFATCOLA
	Local cQuery := ""

	Local aCores := {}


	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MFATCOL" , __cUserID )

	Private cCadastro := "Informações de Coleta"
	Private aRotina   := { { "Pesquisar" , "AxPesqui"  , 0, 1, 0, .F. },;
	{ "Visualizar", "A410Visual", 0, 2, 0, Nil },;
	{ "Sol.Coleta", "U_MFATSOCOL",0, 3, 0, Nil },;
	{ "Inf.Coleta", "U_MFATCOLI", 0, 4, 0, Nil },;
	{ "Rel.Coleta", "U_RFAT110", 0, 5, 0, Nil },;
	{ "Legenda   ", "U_MFATCOLL", 0, 6, 0, Nil },;
	{ "Inform Filtro", "U_InfFilt", 0, 7, 0, Nil } }

	aCores := { {"(C5_CONDPAG == '100') .AND. Empty(C5_NOTA) .AND. C5_REIMP == 0 .AND. C5_XRCOL <> '1' " , 'ENABLE'  },;
	{"( C5_CONDPAG == '100') .AND. Empty(C5_NOTA) .AND. C5_REIMP == 1" , 'DISABLE' },;
	{"( C5_CONDPAG == '100') .AND. Empty(C5_NOTA) .AND. C5_REIMP == 0 .AND. C5_XRCOL == '1' " ,'BR_AMARELO' }}

	cQuery := "UPDATE " + RetSQLName( "SC5" )
	cQuery += "   SET C5_REIMP = Nvl( ( SELECT COUNT(*) "
	cQuery += "                           FROM " + RetSQLName( "SZ4" )
	cQuery += "                          WHERE Z4_FILIAL  = C5_FILIAL "
	cQuery += "                            AND Z4_PEDIDO  = C5_NUM "
	cQuery += "                            AND Z4_EVENTO  = 'Coleta' "
	cQuery += "                            AND D_E_L_E_T_ = ' ' ), 0 ) "
	cQuery += " WHERE C5_TPFRETE  = 'F' "
	cQuery += "   AND C5_X_CANC  != 'C' "
	cQuery += "   AND C5_X_REP   != 'R' "
	cQuery += "   AND C5_LIBEROK != ' ' "
	cQuery += "   AND C5_NOTA     = ' ' "
	cQuery += "   AND C5_BLQ      = ' ' "
	cQuery += "   AND C5_XENTREG >= '20100301' "
	cQuery += "   AND C5_SOLCOL  != ' ' "
	cQuery += "   AND C5_COLETA  != ' ' "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	TCSQLExec( cQuery )
	TCRefresh( 'SC5' )


	MBrowse( Nil, Nil, Nil, Nil, "SC5",{{"Dt.Env.Email","C5_SOLCOL"}}, , , , , aCores )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATCOL   ºAutor  ³Microsiga           º Data ³  06/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATCOLI

	Local cMotivo := Space( TamSx3("Z4_MOTIVO")[1] )

	/*
	If Empty(SC5->C5_SOLCOL)
	MsgStop('Solicitacao de Coleta nao efetuada','Atençao')
	Return .f.
	Endif
	*/

	If MsgGet2("Informações Coleta", "Coleta:", @cMotivo, "@S40", { || .T. } )
		If !Empty( cMotivo )
			If SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_TRANSP ) ) .and. Empty( SA4->A4_EMAILCO )
				RecLock( "SC5", .F. )
				U_GrvLogPd( SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Solicitacao Coleta", "Solicitado Coleta em "+dToc(dDatabase)+" as "+time() )
				SC5->C5_SOLCOL:=dDataBase
				SC5->( MsUnLock() )
			Endif
			U_GrvLogPd( SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Coleta", cMotivo )
			MsgInfo( "Informações de Coleta Gravada" )
			RecLock( "SC5", .F. )
			SC5->C5_REIMP := 1
			SC5->C5_COLETA := Left(@cMotivo,40)
			SC5->C5_DTCOL  := dDataBase
			SC5->( MsUnLock() )
		Else
			MsgStop( "Informações de Coleta Cancelada" )
		Endif
	Else
		MsgStop( "Informações de Coleta Cancelada" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATCOL   ºAutor  ³Microsiga           º Data ³  06/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATSOCOL
	Local cMsgTransp:='Conta de Email para Coleta nao informada no Cadastro de Transportadoras'

	If ! Empty( SC5->C5_COLETA )
		MsgStop('Coleta ja agendada para este Pedido','Atençao')
		Return .f.
	Endif

	If Empty( SC5->C5_TRANSP )
		MsgStop('Transportadora nao Informada no Pedido','Atençao')
		Return .f.
	Endif

	cMsgTransp+=chr(13)+chr(10)
	cMsgTransp+="Caso a transportadora nao possua Email, utilizar o Inf.Coleta Diretamente"

	If SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_TRANSP ) ) .and. Empty( SA4->A4_EMAILCO )
		MsgStop(cMsgTransp,'Atençao')
		Return .f.
	Endif

	If MsgYesNo( "Solicitar Coleta para este pedido "+SC5->C5_NUM+"?" )
		If ! EmailCol(SC5->C5_NUM)
			MsgStop("O Sistema não conseguiu enviar o email. Verifique as configurações de Usuario/Conta Email" )
		Endif
	Else
		MsgStop( "Solicitacao de Coleta Cancelada" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EmailCol  ºAutor  ³Microsiga           º Data ³  22/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EmailCol(cPedido)
	Local aArea    := GetArea()
	Local lRet     := .T.
	Local cExecute 	:= "notes.exe" //"outlook.exe" //
	//Local cFile    := GetTempPath() + StrZero( Val( cPedido ), 8, 0 ) + ".HTML"
	Local cIniFile := GetADV97()
	Local cStartPath:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
	Local cFile    := cStartPath
	Local cArqHtml := StrZero( Val( cPedido ), 8, 0 ) + ".HTML"
	Local _nReg5   := SC5->( recno() )
	Local _nReg6   := SC6->( recno() )
	Local lRet     := .t.

	Local cFilterSC5 := ""

	If .not. (File (GetTempPath()+"colorschememapping.xml"))
		Copy File colorschememapping.xml to (GetTempPath()+"colorschememapping.xml")
	endif
	If .not. (File (GetTempPath()+"filelist.xml"))
		Copy File filelist.xml to (GetTempPath()+"filelist.xml")
	endif
	If .not. (File (GetTempPath()+"themedata.thmx"))
		Copy File themedata.thmx to (GetTempPath()+"themedata.thmx")
	endif
	If .not. (File (GetTempPath()+"image001.jpg"))
		Copy File image001.jpg to (GetTempPath()+"image001.jpg")
	endif
	If .not. (File (GetTempPath()+"lgrl_01.jpg"))
		Copy File LOGO.jpg to (GetTempPath()+"lgrl_01.jpg")
	endif

	lRet := GerarHtml( cFile+cArqHtml, cPedido )

	If lRet

		U_GrvLogPd( SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Solicitacao Coleta", "Solicitado Coleta em "+dToc(dDatabase)+" as "+time() )
		cmail := SA4->A4_EMAILCO
		cCompl := 'mailto:'+ alltrim(cmail) //+ '?cc='+alltrim(cCopia)
		cAssunto := "Solicitacao Coleta Pedido "+SC5->C5_NUM
		if !empty(cAssunto)
			cCompl += '?Subject=' + STRTRAN(ALLTRIM(cAssunto),' ','%20')
		endif

		cParam := cCompl
		cAnexo :=  AllTrim( GetTempPath() )

		bOk := CpyS2T( cFile+cArqHtml , cAnexo, .F. )

		If bOk
			cParam += "?Attach=" +cAnexo+cArqHtml  + ""
		Endif

		// mailto:manuel.seixas@imcd.fr?Subject=test mail with attachment?Attach=C:\temp\Attach.pdf

		//	ShellExecute("open","chrome.exe",cFile,"", 1 )
		ShellExecute('open',cExecute, cParam,'',1)

		IF MsgYesNo("Confirma o envio do Email para o pedido "+SC5->C5_NUM+" em "+dtoc(dDataBase) +" ?"    )
			SC5->(RecLock('SC5',.F.))
			SC5->C5_SOLCOL:=dDataBase
			SC5->(MsUnlock())
		Endif

	Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATCOL   ºAutor  ³Microsiga           º Data ³  06/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATCOLL

	BrwLegenda( cCadastro, "Legenda", { {"ENABLE" , "Sem Informações Coleta" },;
	{"DISABLE", "Com Informações Coleta" },;
	{"BR_AMARELO","Com Solicitação de Recoleta"  }})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATCOL   ºAutor  ³Microsiga           º Data ³  06/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATCOLF
	u_MFATCOL()
return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerarHtml ºAutor  ³Microsiga           º Data ³  22/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerarHtml( cFile, cPedido )
	Local nHandle := 0
	Local cNomVen := space( len( SA3->A3_NOME ) )
	Local cVenInt := space( len( SA3->A3_NOME ) )
	Local cTelInt := space( len( SA3->A3_TEL ) )
	Local cEmaInt := space( len( SA3->A3_EMAIL ) )
	Local cCfop   := ""
	Local cPedCli := ""
	Local cDesCfo := ""
	Local memoObs := ""
	Local cAliCF  := ""
	Local _cNome  := ""
	Local _cCgc   := ""
	Local _cTel   := ""
	Local _cEEnt  := ""
	Local _cCepe  := ""
	Local _cBaie  := ""
	Local _cCide  := ""
	Local _cEste  := ""
	Local aSX513  := {}
	Local nX5     := 0

	cAliCF := "SA1"

	//cNomVen := NomeVend()

	//memoObs := MemoSUA()

	SE4->( dbSeek( xFilial( "SE4" ) + SC5->C5_CONDPAG ) )
	SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_TRANSP ) )
	(cAliCF)->( dbSeek( xFilial( cAliCF ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
	if SC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM ) )
		cCfop := SC6->C6_CF
		cPedCli := SC6->C6_PEDCLI
	endif
	
	aSX513 := FWGetSX5("13",cCfop)

	for nX5 := 1 to len(aSX513)
		cDesCfo := aSX513[1][4]
	next nX5

	_cNome := SA1->A1_NOME
	_cCgc  := SA1->A1_CGC
	_cTel  := "("+SA1->A1_DDD+") "+SA1->A1_TEL
	_cEEnt := SA1->A1_END
	_cCepe := SA1->A1_CEP
	_cBaie := SA1->A1_BAIRRO
	_cCide := SA1->A1_MUN
	_cEste := SA1->A1_EST

	If (File (cFile))
		FErase (cFile)
	Endif

	nHandle	:= MsFCreate(cFile)

	htHeadPed( nHandle )

	cLogoWeb := "http://www.informationportal.imcdgroup.com/images/logoIMCD_m.png"

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<body lang=PT-BR link=blue vlink=purple style='tab-interval:35.4pt'> " )  //Troquei apost.p/aspas pois o html usa apost.nesse momento
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '<div class=Section1> ' )
	Fwrite( nHandle, ' ' )

	//htLogoMak( nHandle )

	Fwrite( nHandle, '<a> <img width="259" height="89" border="0"  src="'+cLogoWeb+'"</a> ')

	Fwrite( nHandle, "<p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center'>"+;
	"<span style='font-size:14.0pt;font-family:" +;
	'"Arial","sans-serif"' + "'><i>Solicitação de Coleta</i></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center'>"+;
	"<span style='font-size:12.0pt;font-family:" +;
	'"Arial"' + "'> Pedido IMCD: </span><span style='font-size:18.0pt;font-family:" +;
	'"Arial"' + "'>" + SC5->C5_NUM + "<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center'>"+;
	"<span style='font-size:12.0pt;font-family:" +;
	'"Arial"' + "'>Solicitado em: "+dtoc(dDataBase)+"</span><span style='font-size:18.0pt;font-family:" +;
	'"Arial"' + "'>" + "<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'> " )
	Fwrite( nHandle, SM0->M0_ENDENT+" - "+SM0->M0_BAIRENT+" - "+SM0->M0_CIDENT+" - "+SM0->M0_ESTENT+" - CEP: "+SM0->M0_CEPENT )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>" )
	Fwrite( nHandle, "Fone: +5511-4800-3911/3912 <span style='mso-spacerun:yes'>  </span>- e-mail <a " )
	Fwrite( nHandle, 'href="mailto:logistica.imcd@imcdbrasil.com.br">logistica.imcd@imcdbrasil.com.br</a> – internet: <a ' )
	Fwrite( nHandle, 'href="http://www.imcdgroup.com">www.imcdgroup.com</a><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>COLETA " )
	Fwrite( nHandle, 'SOLICITADA EM: '+dtoc(dDatabase)+'<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )

	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Nr. Pedido Cliente: "+cPedCli+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Data: " + dtoc( dDataBase ) + "<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Cliente: " + _cNome )
	Fwrite( nHandle, "<span style='mso-spacerun:yes'>        </span>CNPJ: " )
	Fwrite( nHandle, Trans(_cCgc,'@R 99.999.999/9999-99')+'<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Contato: " )
	Fwrite( nHandle, SC5->C5_XNOMCON+'<span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>                                      </span>Telefone: " )
	Fwrite( nHandle, _cTel+"<span style='mso-spacerun:yes'>     </span>               <o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Transportadora: "+SA4->A4_NOME )
	Fwrite( nHandle, "<span style='mso-spacerun:yes'>             </span>CNPJ: "+Trans(SA4->A4_CGC,'@R 99.999.999/9999-99')+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Contato: "+SA4->A4_CONTATO+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>E-Mail: "+SA4->A4_EMAIL+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>E-Mail Coleta: "+SA4->A4_EMAILCO+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Local de Entrega: " +_cEEnt+ "<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span>  CEP: '+_cCepe+'<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Bairro: "+ _cBaie +"<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'>" )
	Fwrite( nHandle, '</span>Município: '+_cCide+' <span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>" )
	Fwrite( nHandle, '</span>UF : ' + _cEste + '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

	htItens( nHandle )

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Obs.: <span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>1-) HORÁRIO DE ATENDIMENTO: Das 08:00 às 11:30 e das 12:30 às 16:00.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>2-)  ")
	Fwrite( nHandle, "Validar coleta através do email: coletas@imcdbrasil.com.br ou pelo telefone: (11)4800-3911/3912")
	Fwrite( nHandle, " informando o Número da Coleta e responsável.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>3-)  Produtos alimentícios, farmacêuticos, cosméticos e outros para uso humano não podem ser carregados com os de natureza controlada.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>4-)  Não é permitido a entrada trajando tênis, bermuda e camiseta regata.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>5-)  Não carregamos veículos com placa cinza(DETRAN)(Salvo veículo de propriedade do cliente que esteja registrado em nome do mesmo.)<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>6-)  Trazer ordem de coleta em mãos ou enviar por e-mail: coletas@imcdbrasil.com.br. <span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>7-)  Em caso de mercadorias de natureza controlada, será exigido:  Kit de emergência /curso MOPP / Placas de risco do Produto.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )

	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>8-)  Quando houver mais de 01 produto químico classificado no caminhão, trazer placa laranja; motorista e ajudantes deverão ter o kit de emergência.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )

	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>9-)  Quando se tratar de quantidade isenta, ignorar exigências do item 7 da observação.<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )

	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>10-) Outras exigências da legislação de transportes serão analisadas na inspeção do veículo (check list interno).<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )

	/*
	"	Trazer ordem de coleta ou enviar por e-mail/fax(11-4360-6494 / coletas@makeni.com.br;)
	"	Quando os produtos de natureza controlada, enviar equipamentos:  Kit de emergência /curso MOPP / Placas de risco do Produto. Quando houver mais de 01 produto químico classificado no caminhão trazer placa laranja, cada pessoa deve ter seu kit de emergência.





	memoObs:="HORARIO DE ATENDIMENTO das 08h as 16h:30m " +chr(13)+chr(10)
	memoObs+="	Para sequencia de agendamento favor responder por e-mail (coletas@makeni.com.br) Fax.(0XX11)(4360-6494) ou contato (0XX11)(4360-6400) "+chr(13)+chr(10)
	memoObs+="  para confirmacao da coleta com o Numero da Solicitacao da Coleta. "+chr(13)+chr(10)
	memoObs+="  Produtos alimenticios, farmaceuticos, cosmeticos, nao podem ser carregados com produto de natureza controlada. " +chr(13)+chr(10)
	memoObs+="	Nao e permitido a entrada de tenis, bermuda, camiseta regata. "
	memoObs+="	Nao carregamos veiculos com placa cinza(DETRAN) (Salvo, veiculo de propriedade do cliente, que esteja registrado em nome do cliente.) "+chr(13)+chr(10)
	memoObs+="	Trazer ordem de coleta ou enviar por e-mail/fax(11-4360-6494 / coletas@makeni.com.br) "+chr(13)+chr(10)
	memoObs+="	Quando for produtos de natureza controlada, enviar equipamentos:  Kit de emergencia /curso MOPP / Placas de risco do Produto. "+chr(13)+chr(10)
	memoObs+="  Quando houver mais de 01 produto quimico classificado no caminhao trazer placa laranja, cada pessoa deve ter seu kit de emergencia. "

	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Obs.: <o:p></o:p></span></p> " )
	*/

	/*
	if .not. Empty( SC5->C5_HIST )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Obs: "+SC5->C5_HIST+"<o:p></o:p></span></p> " )
	endif
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	if .not. Empty( SC5->C5_HIST )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>"+memoObs+"<o:p></o:p></span></p> " )
	else
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Obs: "+memoObs+"<o:p></o:p></span></p> " )
	endif
	*/

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</body> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</html> ' )


	If (nHandle>=0)
		FClose (nHandle)
	Endif

	cEmail:=Alltrim(SA4->A4_EMAILCO)

	If ( At(';',cEmail)==0 )
		cEmail+=Chr(59)
	Endif

	//lEmail:=U_ABRENOTES( cEmail, {cFile}, "", "Solicitacao de Coleta "+SC5->C5_NUM)
	//lEmail := U_MKEnvMail( ,,,, cEmail, "Solicitacao de Coleta "+SC5->C5_NUM, "Solicitacao de Coleta "+SC5->C5_NUM , cFile, .F. )
	lEmail := FILE(cFile)

Return lEmail

/*
Head do HTML
*/
Static Function htHeadPed( nHandle )

	Fwrite( nHandle, '<html xmlns:v="urn:schemas-microsoft-com:vml" ' )
	Fwrite( nHandle, 'xmlns:o="urn:schemas-microsoft-com:office:office" ' )
	Fwrite( nHandle, 'xmlns:w="urn:schemas-microsoft-com:office:word" ' )
	Fwrite( nHandle, 'xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" ' )
	Fwrite( nHandle, 'xmlns="http://www.w3.org/TR/REC-html40"> ' )
	Fwrite( nHandle, '<head> ' )
	Fwrite( nHandle, '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"> ' )
	Fwrite( nHandle, '<meta name=ProgId content=Word.Document> ' )
	Fwrite( nHandle, '<meta name=Generator content="Microsoft Word 12"> ' )
	Fwrite( nHandle, '<meta name=Originator content="Microsoft Word 12"> ' )
	Fwrite( nHandle, '<link rel=File-List href="Layout%20Pedido_arquivos/filelist.xml"> ' )
	Fwrite( nHandle, '<!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:DocumentProperties> ' )
	Fwrite( nHandle, '  <o:Author>Administrador</o:Author> ' )
	Fwrite( nHandle, '  <o:Template>Normal</o:Template> ' )
	Fwrite( nHandle, '  <o:LastAuthor>Administrador</o:LastAuthor> ' )
	Fwrite( nHandle, '  <o:Revision>2</o:Revision> ' )
	Fwrite( nHandle, '  <o:TotalTime>37</o:TotalTime> ' )
	Fwrite( nHandle, '  <o:Created>2009-11-26T12:37:00Z</o:Created> ' )
	Fwrite( nHandle, '  <o:LastSaved>2009-11-26T12:37:00Z</o:LastSaved> ' )
	Fwrite( nHandle, '  <o:Pages>1</o:Pages> ' )
	Fwrite( nHandle, '  <o:Words>340</o:Words> ' )
	Fwrite( nHandle, '  <o:Characters>1841</o:Characters> ' )
	Fwrite( nHandle, '  <o:Lines>15</o:Lines> ' )
	Fwrite( nHandle, '  <o:Paragraphs>4</o:Paragraphs> ' )
	Fwrite( nHandle, '  <o:CharactersWithSpaces>2177</o:CharactersWithSpaces> ' )
	Fwrite( nHandle, '  <o:Version>12.00</o:Version> ' )
	Fwrite( nHandle, ' </o:DocumentProperties> ' )
	Fwrite( nHandle, '</xml><![endif]--> ' )
	Fwrite( nHandle, '<link rel=themeData href="Layout%20Pedido_arquivos/themedata.thmx"> ' )
	Fwrite( nHandle, '<link rel=colorSchemeMapping ' )
	Fwrite( nHandle, 'href="Layout%20Pedido_arquivos/colorschememapping.xml"> ' )
	Fwrite( nHandle, '<!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <w:WordDocument> ' )
	Fwrite( nHandle, '  <w:SpellingState>Clean</w:SpellingState> ' )
	Fwrite( nHandle, '  <w:GrammarState>Clean</w:GrammarState> ' )
	Fwrite( nHandle, '  <w:TrackMoves>false</w:TrackMoves> ' )
	Fwrite( nHandle, '  <w:TrackFormatting/> ' )
	Fwrite( nHandle, '  <w:HyphenationZone>21</w:HyphenationZone> ' )
	Fwrite( nHandle, '  <w:PunctuationKerning/> ' )
	Fwrite( nHandle, '  <w:DrawingGridHorizontalSpacing>5,5 pt</w:DrawingGridHorizontalSpacing> ' )
	Fwrite( nHandle, '  <w:DisplayHorizontalDrawingGridEvery>2</w:DisplayHorizontalDrawingGridEvery> ' )
	Fwrite( nHandle, '  <w:ValidateAgainstSchemas/> ' )
	Fwrite( nHandle, '  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid> ' )
	Fwrite( nHandle, '  <w:IgnoreMixedContent>false</w:IgnoreMixedContent> ' )
	Fwrite( nHandle, '  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText> ' )
	Fwrite( nHandle, '  <w:DoNotPromoteQF/> ' )
	Fwrite( nHandle, '  <w:LidThemeOther>PT-BR</w:LidThemeOther> ' )
	Fwrite( nHandle, '  <w:LidThemeAsian>X-NONE</w:LidThemeAsian> ' )
	Fwrite( nHandle, '  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript> ' )
	Fwrite( nHandle, '  <w:Compatibility> ' )
	Fwrite( nHandle, '   <w:BreakWrappedTables/> ' )
	Fwrite( nHandle, '   <w:SnapToGridInCell/> ' )
	Fwrite( nHandle, '   <w:WrapTextWithPunct/> ' )
	Fwrite( nHandle, '   <w:UseAsianBreakRules/> ' )
	Fwrite( nHandle, '   <w:DontGrowAutofit/> ' )
	Fwrite( nHandle, '   <w:SplitPgBreakAndParaMark/> ' )
	Fwrite( nHandle, '   <w:DontVertAlignCellWithSp/> ' )
	Fwrite( nHandle, '   <w:DontBreakConstrainedForcedTables/> ' )
	Fwrite( nHandle, '   <w:DontVertAlignInTxbx/> ' )
	Fwrite( nHandle, '   <w:Word11KerningPairs/> ' )
	Fwrite( nHandle, '   <w:CachedColBalance/> ' )
	Fwrite( nHandle, '  </w:Compatibility> ' )
	Fwrite( nHandle, '  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> ' )
	Fwrite( nHandle, '  <m:mathPr> ' )
	Fwrite( nHandle, '   <m:mathFont m:val="Cambria Math"/> ' )
	Fwrite( nHandle, '   <m:brkBin m:val="before"/> ' )
	Fwrite( nHandle, '   <m:brkBinSub m:val="&#45;-"/> ' )
	Fwrite( nHandle, '   <m:smallFrac m:val="off"/> ' )
	Fwrite( nHandle, '   <m:dispDef/> ' )
	Fwrite( nHandle, '   <m:lMargin m:val="0"/> ' )
	Fwrite( nHandle, '   <m:rMargin m:val="0"/> ' )
	Fwrite( nHandle, '   <m:defJc m:val="centerGroup"/> ' )
	Fwrite( nHandle, '   <m:wrapIndent m:val="1440"/> ' )
	Fwrite( nHandle, '   <m:intLim m:val="subSup"/> ' )
	Fwrite( nHandle, '   <m:naryLim m:val="undOvr"/> ' )
	Fwrite( nHandle, '  </m:mathPr></w:WordDocument> ' )
	Fwrite( nHandle, '</xml><![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true" ' )
	Fwrite( nHandle, '  DefSemiHidden="true" DefQFormat="false" DefPriority="99" ' )
	Fwrite( nHandle, '  LatentStyleCount="267"> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="0" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Normal"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="heading 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 7"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 8"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 9"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="10" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Title"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="11" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtitle"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="22" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Strong"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="20" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="59" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Table Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="1" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="No Spacing"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="34" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="29" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Quote"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="30" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="19" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="21" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="31" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="32" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="33" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Book Title"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="37" Name="Bibliography"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"/> ' )
	Fwrite( nHandle, ' </w:LatentStyles> ' )
	Fwrite( nHandle, '</xml><![endif]--> ' )
	Fwrite( nHandle, '<style> ' )
	Fwrite( nHandle, '<!-- ' )
	Fwrite( nHandle, ' /* Font Definitions */ ' )
	Fwrite( nHandle, ' @font-face ' )
	Fwrite( nHandle, '	{font-family:"Cambria Math"; ' )
	Fwrite( nHandle, '	panose-1:2 4 5 3 5 4 6 3 2 4; ' )
	Fwrite( nHandle, '	mso-font-charset:0; ' )
	Fwrite( nHandle, '	mso-generic-font-family:roman; ' )
	Fwrite( nHandle, '	mso-font-pitch:variable; ' )
	Fwrite( nHandle, '	mso-font-signature:-1610611985 1107304683 0 0 159 0;} ' )
	Fwrite( nHandle, '@font-face ' )
	Fwrite( nHandle, '	{font-family:Calibri; ' )
	Fwrite( nHandle, '	panose-1:2 15 5 2 2 2 4 3 2 4; ' )
	Fwrite( nHandle, '	mso-font-charset:0; ' )
	Fwrite( nHandle, '	mso-generic-font-family:swiss; ' )
	Fwrite( nHandle, '	mso-font-pitch:variable; ' )
	Fwrite( nHandle, '	mso-font-signature:-1610611985 1073750139 0 0 159 0;} ' )
	Fwrite( nHandle, ' /* Style Definitions */ ' )
	Fwrite( nHandle, ' p.MsoNormal, li.MsoNormal, div.MsoNormal ' )
	Fwrite( nHandle, '	{mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-parent:""; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:0cm; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'a:link, span.MsoHyperlink ' )
	Fwrite( nHandle, '	{mso-style-priority:99; ' )
	Fwrite( nHandle, '	color:blue; ' )
	Fwrite( nHandle, '	mso-themecolor:hyperlink; ' )
	Fwrite( nHandle, '	text-decoration:underline; ' )
	Fwrite( nHandle, '	text-underline:single;} ' )
	Fwrite( nHandle, 'a:visited, span.MsoHyperlinkFollowed ' )
	Fwrite( nHandle, '	{mso-style-noshow:yes; ' )
	Fwrite( nHandle, '	mso-style-priority:99; ' )
	Fwrite( nHandle, '	color:purple; ' )
	Fwrite( nHandle, '	mso-themecolor:followedhyperlink; ' )
	Fwrite( nHandle, '	text-decoration:underline; ' )
	Fwrite( nHandle, '	text-underline:single;} ' )
	Fwrite( nHandle, 'p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpFirst, li.MsoListParagraphCxSpFirst, div.MsoListParagraphCxSpFirst ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:0cm; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	margin-bottom:.0001pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpMiddle, li.MsoListParagraphCxSpMiddle, div.MsoListParagraphCxSpMiddle ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:0cm; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	margin-bottom:.0001pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpLast, li.MsoListParagraphCxSpLast, div.MsoListParagraphCxSpLast ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '.MsoChpDefault ' )
	Fwrite( nHandle, '	{mso-style-type:export-only; ' )
	Fwrite( nHandle, '	mso-default-props:yes; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '.MsoPapDefault ' )
	Fwrite( nHandle, '	{mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	line-height:115%;} ' )
	Fwrite( nHandle, '@page Section1 ' )
	Fwrite( nHandle, '	{size:595.3pt 841.9pt; ' )
	Fwrite( nHandle, '	margin:36.0pt 36.0pt 36.0pt 36.0pt; ' )
	Fwrite( nHandle, '	mso-header-margin:35.4pt; ' )
	Fwrite( nHandle, '	mso-footer-margin:35.4pt; ' )
	Fwrite( nHandle, '	mso-paper-source:0;} ' )
	Fwrite( nHandle, 'div.Section1 ' )
	Fwrite( nHandle, '	{page:Section1;} ' )
	Fwrite( nHandle, ' /* List Definitions */ ' )
	Fwrite( nHandle, ' @list l0 ' )
	Fwrite( nHandle, '	{mso-list-id:1430926773; ' )
	Fwrite( nHandle, '	mso-list-type:hybrid; ' )
	Fwrite( nHandle, '	mso-list-template-ids:-204317186 68550673 68550681 68550683 68550671 68550681 68550683 68550671 68550681 68550683;} ' )
	Fwrite( nHandle, '@list l0:level1 ' )
	Fwrite( nHandle, '	{mso-level-text:"%1\)"; ' )
	Fwrite( nHandle, '	mso-level-tab-stop:none; ' )
	Fwrite( nHandle, '	mso-level-number-position:left; ' )
	Fwrite( nHandle, '	text-indent:-18.0pt;} ' )
	Fwrite( nHandle, '@list l1 ' )
	Fwrite( nHandle, '	{mso-list-id:1470628229; ' )
	Fwrite( nHandle, '	mso-list-type:hybrid; ' )
	Fwrite( nHandle, '	mso-list-template-ids:-579823852 68550673 68550681 68550683 68550671 68550681 68550683 68550671 68550681 68550683;} ' )
	Fwrite( nHandle, '@list l1:level1 ' )
	Fwrite( nHandle, '	{mso-level-text:"%1\)"; ' )
	Fwrite( nHandle, '	mso-level-tab-stop:none; ' )
	Fwrite( nHandle, '	mso-level-number-position:left; ' )
	Fwrite( nHandle, '	text-indent:-18.0pt;} ' )
	Fwrite( nHandle, 'ol ' )
	Fwrite( nHandle, '	{margin-bottom:0cm;} ' )
	Fwrite( nHandle, 'ul ' )
	Fwrite( nHandle, '	{margin-bottom:0cm;} ' )
	Fwrite( nHandle, '--> ' )
	Fwrite( nHandle, '</style> ' )
	Fwrite( nHandle, '<!--[if gte mso 10]> ' )
	Fwrite( nHandle, '<style> ' )
	Fwrite( nHandle, ' /* Style Definitions */ ' )
	Fwrite( nHandle, ' table.MsoNormalTable ' )
	Fwrite( nHandle, '	{mso-style-name:"Tabela normal"; ' )
	Fwrite( nHandle, '	mso-tstyle-rowband-size:0; ' )
	Fwrite( nHandle, '	mso-tstyle-colband-size:0; ' )
	Fwrite( nHandle, '	mso-style-noshow:yes; ' )
	Fwrite( nHandle, '	mso-style-priority:99; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-parent:""; ' )
	Fwrite( nHandle, '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; ' )
	Fwrite( nHandle, '	mso-para-margin-top:0cm; ' )
	Fwrite( nHandle, '	mso-para-margin-right:0cm; ' )
	Fwrite( nHandle, '	mso-para-margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	mso-para-margin-left:0cm; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '</style> ' )
	Fwrite( nHandle, '<![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:shapedefaults v:ext="edit" spidmax="2050"/> ' )
	Fwrite( nHandle, '</xml><![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:shapelayout v:ext="edit"> ' )
	Fwrite( nHandle, '  <o:idmap v:ext="edit" data="1"/> ' )
	Fwrite( nHandle, ' </o:shapelayout></xml><![endif]--> ' )
	Fwrite( nHandle, '</head> ' )

return( .T. )


/*
Logotipo da Makeni
*/
Static Function htLogoMak( nHandle )
	Local _cLogo := GetTempPath() + "lgrl_01.jpg"

	Fwrite( nHandle, "<p class=MsoNormal><span style='mso-fareast-language:PT-BR;mso-no-proof:yes'><!--[if gte vml 1]><v:shapetype " )
	Fwrite( nHandle, ' id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t" ' )
	Fwrite( nHandle, ' path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f"> ' )
	Fwrite( nHandle, ' <v:stroke joinstyle="miter"/> ' )
	Fwrite( nHandle, ' <v:formulas> ' )
	Fwrite( nHandle, '  <v:f eqn="if lineDrawn pixelLineWidth 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @0 1 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum 0 0 @1"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @2 1 2"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @3 21600 pixelWidth"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @3 21600 pixelHeight"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @0 0 1"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @6 1 2"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @7 21600 pixelWidth"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @8 21600 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @7 21600 pixelHeight"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @10 21600 0"/> ' )
	Fwrite( nHandle, ' </v:formulas> ' )
	Fwrite( nHandle, ' <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/> ' )
	Fwrite( nHandle, ' <o:lock v:ext="edit" aspectratio="t"/> ' )
	Fwrite( nHandle, '</v:shapetype><v:shape id="Imagem_x0020_0" o:spid="_x0000_i1025" type="#_x0000_t75" ' )
	Fwrite( nHandle, " alt=" + '"LOGO.jpg"' + "style='width:81.75pt;height:78pt;visibility:visible; " )
	Fwrite( nHandle, " mso-wrap-style:square'> " )
	Fwrite( nHandle, ' <v:imagedata src="'+_cLogo+'" o:title="LOGO"/> ' )
	Fwrite( nHandle, '</v:shape><![endif]--><![if !vml]><img width=109 height=104 ' )
	Fwrite( nHandle, 'src="'+_cLogo+'" alt=LOGO.jpg v:shapes="Imagem_x0020_0"><![endif]></span></p> ' )

Return( .T. )


/*
Itens do Pedido
*/
Static Function htItens( nHandle )
	Local _nIpi := 0
	Local _nQtd := 0
	Local _nPrc := 0

	Fwrite( nHandle, '<div class=Section1> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=725 ' )
	Fwrite( nHandle, " style='width:584.05pt;border-collapse:collapse;border:none;mso-border-alt: " )
	Fwrite( nHandle, ' solid black .5pt;mso-border-themecolor:text1;mso-yfti-tbllook:1184;mso-padding-alt: ' )
	Fwrite( nHandle, " 0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, " <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'> " )
	Fwrite( nHandle, "  <td width=82 valign=top style='width:61.7pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>ITEM</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=227 valign=top style='width:210.5pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PRODUTO</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>QUANTIDADE/UN</p> " )
	Fwrite( nHandle, '  </td> ' )

	Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PRECO UNIT</p> " )
	Fwrite( nHandle, '  </td> ' )

	Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PRECO TOTAL</p> " )
	Fwrite( nHandle, '  </td> ' )

	Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PESO LIQ</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PESO BRUTO</p> " )
	Fwrite( nHandle, '  </td> ' )

	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>TIPO EMBALAGEM</p> " )
	Fwrite( nHandle, '  </td> ' )

	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>NUMERO VOLUMES</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>COD ONU</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>CLASSE RISCO</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>NUMERO RISCO</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>RISCO SUBSIDIARIO</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, ' </tr> ' )

	Do While .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial( "SC6" ) .and.;
	SC6->C6_NUM    == SC5->C5_NUM
		SB1->( dbSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )

		_nQtd := SC6->C6_QTDVEN
		_nVol := 0

		Fwrite( nHandle, ' ' )
		Fwrite( nHandle, " <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'> " )
		Fwrite( nHandle, "  <td width=82 valign=top style='width:61.7pt;border:solid black 1.0pt; " )
		Fwrite( nHandle, '  mso-border-themecolor:text1;border-top:none;mso-border-top-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-top-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>" + SC6->C6_PRODUTO + "</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=227 valign=top style='width:210.5pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1_DESC+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nQtd,"@E 999,999,999.99" )+" "+SC6->C6_UM+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( SC6->C6_PRCVEN,"@E 999,999,999,999.99" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nQtd*SC6->C6_PRCVEN,"@E 999,999,999,999.99" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nQtd ,"@E 999,999.9999" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( SB1->B1_PESBRU*_nQtd,"@E 999,999.9999" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		SZ2->(dbseek(xFilial('SZ2')+SB1->B1_EMB))

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+Alltrim(SZ2->Z2_DESC)+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		if Empty(SB1->B1_LOTEMUL)
			_nVol := 1   // Granel
		else
			_nVol := _nQtd/SB1->B1_LOTEMUL
		endif

		Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, '  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nVol,"@E 9,999,999" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1__CODONU+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1_CLARIS+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1_NUMRIS+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1_CLARSUB+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, ' </tr> ' )


		SC6->( dbSkip() )

	EndDo

	Fwrite( nHandle, '</table> ' )
	Fwrite( nHandle, '<p class=MsoNormal><o:p>&nbsp;</o:p></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

Return( .T. )


/*
Informações Gerais do final do Pedido
*/
Static Function htInforma( nHandle )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Informações " )
	Fwrite( nHandle, 'Gerais:<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:"+ '"Arial","sans-serif"' + "'>Vide " )
	Fwrite( nHandle, 'Termo de Informações Comerciais abaixo.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>OBSERVAÇÔES:<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>1) O " )
	Fwrite( nHandle, 'efetivo embarque fica sujeito ainda, as limitações das linhas de crédito e / ou ' )
	Fwrite( nHandle, 'impedimento de força maior;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>2) O " )
	Fwrite( nHandle, 'faturamento ocorrerá em Reais (R$), utilizando-se a taxa de dólar de venda ' )
	Fwrite( nHandle, 'comercial (PTAX) publicada na Gazeta Mercantil, na data efetiva do faturamento;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>3) " )
	Fwrite( nHandle, 'Quando a negociação ocorrer em reais, desconsiderar a informação acima;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>4) " )
	Fwrite( nHandle, 'Esta proposta comercial é valida por 48 horas;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>5) " )
	Fwrite( nHandle, 'Entrega será realizada em até 48 horas, após a confirmação do pedido pelo ' )
	Fwrite( nHandle, 'cliente;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>6) " )
	Fwrite( nHandle, 'Pedidos com entregas programadas, superiores a 5 dias da data de confirmação ' )
	Fwrite( nHandle, 'estarão sujeitos a reajustes de preços de acordo com o fabricante ou novas ' )
	Fwrite( nHandle, 'condições de mercado.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>Sem " )
	Fwrite( nHandle, 'mais para o momento, nos colocamos a sua inteira disposição para maiores ' )
	Fwrite( nHandle, 'esclarecimentos.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>Atenciosamente,<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
Return( .T. )


Static Function htTermo( nHandle )

	Fwrite( nHandle, '<div class=Section1> ' )

	Fwrite( nHandle, "<h1 align=center style='text-align:center'><span style='font-size:14.0pt;font-family:" +;
	'"Arial","sans-serif"' + "'>TERMO DE INFORMAÇÕES COMERCIAIS</span></h1> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>O presente termo " )
	Fwrite( nHandle, 'apresenta alguns pressupostos comerciais e operacionais para o fornecimento dos ' )
	Fwrite( nHandle, 'produtos comercializados pela <span class=SpellE>'+SM0->M0_NOMECOM+'</span> ' )
	Fwrite( nHandle, '. <o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>A <span class=SpellE>Makeni</span> " )
	Fwrite( nHandle, 'garante que os produtos comercializados atendem as Especificações Técnicas e as ' )
	Fwrite( nHandle, 'orientações constantes nas <span class=SpellE><span class=GramE>FISPQs</span></span><span ' )
	Fwrite( nHandle, 'class=GramE>(</span> ficha de Informação de Segurança de Produtos Químicos e ' )
	Fwrite( nHandle, 'Especificação Técnica), servindo esta como orientação para ser utilizada na ' )
	Fwrite( nHandle, 'armazenagem e no manuseio dos produtos (Já em seu poder).<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>O envio antecipado das " )
	Fwrite( nHandle, 'licenças exigidas pela legislação é item obrigatório para a aceitação do pedido ' )
	Fwrite( nHandle, 'na <span class=SpellE>'+SM0->M0_NOMECOM+'</span>.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>A <span class=SpellE>"+SM0->M0_NOMECOM+"</span> " )
	Fwrite( nHandle, 'não se responsabiliza pela qualidade dos produtos após a descarga dos produtos <span ' )
	Fwrite( nHandle, 'class=GramE>à</span> granel nas instalações do cliente, ou entrega a seu ' )
	Fwrite( nHandle, 'representante.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>A responsabilidade pela " )
	Fwrite( nHandle, 'descarga de produtos perigosos é de responsabilidade do Destinatário conforme ' )
	Fwrite( nHandle, 'definido no Decreto 96.044/88 - Art.37, portanto o recebimento de embalagens ' )
	Fwrite( nHandle, '(tambores/<span class=SpellE>bombonas</span>) descarregadas de forma <span ' )
	Fwrite( nHandle, 'class=GramE>incorreta(</span> jogado sobre pneus) compromete a qualidade desta ' )
	Fwrite( nHandle, 'e do produto, sem nenhuma responsabilidade por parte da <span class=SpellE>'+SM0->M0_NOMECOM+'</span>, ' )
	Fwrite( nHandle, 'portanto recomendamos a não utilização desta prática.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>A devolução de produtos " )
	Fwrite( nHandle, 'somente será aceita após comunicação à <span class=SpellE>'+SM0->M0_NOMECOM+'</span> da ' )
	Fwrite( nHandle, 'necessidade e aceitação da remessa pela <span class=SpellE>Makeni</span>. ' )
	Fwrite( nHandle, 'Produtos devolvidos estão sujeitos a investigação de conformidade/alteração de ' )
	Fwrite( nHandle, 'características, bem como a não aceitação da devolução caso seja comprovada ' )
	Fwrite( nHandle, 'responsabilidade do recebedor. A autorização da devolução deverá sempre partir ' )
	Fwrite( nHandle, 'da <span class=SpellE>'+SM0->M0_NOMECOM+'</span>.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>Desta forma, qualquer " )
	Fwrite( nHandle, 'reclamação deverá ser comunicada<span class=GramE><span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>  </span></span>antes de efetuada a referida descarga.<o:p></o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>No caso de produtos " )
	Fwrite( nHandle, 'embalados as reclamações poderão ser efetuadas em até 10 dias úteis, apenas ' )
	Fwrite( nHandle, 'para especificação do produto.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>Este termo destina-se " )
	Fwrite( nHandle, 'ao registro da negociação, portanto sujeito a eventual desistência de ambas as ' )
	Fwrite( nHandle, 'partes, desde que com aviso e concordância previa, sem que isto configure ' )
	Fwrite( nHandle, 'quebra de contrato.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'>Estamos confirmando a " )
	Fwrite( nHandle, 'aceitação deste pedido conforme condições de negociações acordadas, entretanto ' )
	Fwrite( nHandle, 'ressaltamos que, a logística de movimentação de produtos é cercada por uma ' )
	Fwrite( nHandle, 'série de legislações, que responsabilizam o <b>transportador, o expedidor e o ' )
	Fwrite( nHandle, 'destinatário.<o:p></o:p></b></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><u><span style='font-family:" + '"Arial","sans-serif"' + "'><o:p><span " )
	Fwrite( nHandle, " style='text-decoration:none'>&nbsp;</span></o:p></span></u></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><u><span style='font-family:" + '"Arial","sans-serif"' + "'><i>Com a<span " )
	Fwrite( nHandle, "class=GramE><span style='mso-spacerun:yes'>  </span></span>indicação para o " )
	Fwrite( nHandle, "transporte dos produtos por <span class=SpellE>V.Sas<span style='font-style: " )
	Fwrite( nHandle, "normal;text-decoration:none;text-underline:none'>,</span></span></i></span></u><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'> a responsabilidade no atendimento as " )
	Fwrite( nHandle, 'legislações abaixo são pertinentes ao contratante do transporte,<span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>  </span>e<span style='mso-spacerun:yes'> " )
	Fwrite( nHandle, "</span>sujeitam-se no embarque<span style='mso-spacerun:yes'>  </span>ao " )
	Fwrite( nHandle, 'atendimento das legislações de: Regulamento de Transporte de Produtos (Dec. ' )
	Fwrite( nHandle, "96044/88 ), Lei Ambiental (Lei<span style='mso-spacerun:yes'>  </span>9605/98), " )
	Fwrite( nHandle, 'licenciamento Polícia Federal ( Portaria 1274/ 03), Incompatibilidade de ' )
	Fwrite( nHandle, 'Produtos (NBR 14619), entretanto o efetivo embarque fica sujeito ainda, as ' )
	Fwrite( nHandle, 'limitações das linhas de crédito e/ou impedimentos de força<span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>  </span>maior.<o:p></o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, "<p class=MsoBodyText><span class=SpellE><span style='font-size:11.0pt;font-family:" + '"Arial","sans-serif"' +;
	"'>"+SM0->M0_NOMECOM+"</span></p>" )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, "<p class=MsoFooter><span style='font-size:8.0pt;font-family:" + '"Arial","sans-serif"' + "'>F CO 01 " )
	Fwrite( nHandle, 'REVISÃO 01 – 07/04/08<o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, '</div> ' )

Return( .T. )


/*
Retorna o nome do vendedor.
*/
Static Function NomeVend()
	Local cNomVen := space( len( SA3->A3_NOME ) )

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND1 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VENDX2 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND3 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND4 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND5 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

return( cNomVen )


/*
*/

Static Function MemoSUA()
	Local cRet := ""

	SUB->( dbsetorder( 4 ) )
	SUA->( dbsetorder( 1 ) )

	if SUB->( dbSeek( xFilial( "SUB" ) + SC5->C5_NUM ) )

		if SUA->( dbSeek( xFilial( "SUA" ) + SUB->UB_NUM ) )

			cRet := MSMM( SUA->UA_CODOBS, 80 )

		endif

	endif

return( cRet )

/*
*/

Static Function verMoeda( nMoeda )
	Local _cRet := "R$"

	if nMoeda == 1
		_cRet := "R$ "
	elseif nMoeda == 2
		_cRet := "US$"
	elseif nMoeda == 3
		_cRet := "UFI"
	elseif nMoeda == 4
		_cRet := "EUR"
	elseif nMoeda == 5
		_cRet := "YEN"
	elseif nMoeda >= 6
		_cRet := "   "
	endif

	Return ( _cRet )



	#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATRETCOLºAutor  ³Robson Sanchez Dias º Data ³  29/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de Retirada das Coletas na Portaria               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATRETCOL

	Local cQuery := ""

	Local aCores := {}

	Local cFiltro
	Local aIndexSC5 := {}
	Local aCpoBrw:={}
	Private bFilBrow  := {|| }
	Private cCadastro := "Retirada de Coletas "
	Private aRotina   := { { "Pesquisar" , "AxPesqui"  , 0, 1, 0, .F. },;
	{ "Ret.Coleta", "U_MFATCOLR", 0, 4, 0, Nil },;
	{ "Rel.Coleta", "U_RFAT110", 0, 3, 0, Nil } }

	lFirst:=.t.
	cFiltro  := "C5_REIMP == 1 .and. !Empty(C5_COLETA)"
	bFilBrow := { || FilBrowse( "SC5", @aIndexSC5, @cFiltro ) }
	Eval( bFilBrow )


	Aadd(aCpoBrw,{AvSx3("C5_COLETA",AV_TITULO),"C5_COLETA"})
	Aadd(aCpoBrw,{AvSx3("C5_DTCOLR",AV_TITULO),"C5_DTCOLR"})
	Aadd(aCpoBrw,{AvSx3("C5_HRCOLR",AV_TITULO),"C5_HRCOLR"})
	Aadd(aCpoBrw,{AvSx3("C5_PORTA",AV_TITULO) ,"C5_PORTA"})
	Aadd(aCpoBrw,{AvSx3("C5_PLACA",AV_TITULO) ,"C5_PLACA"})

	MBrowse( Nil, Nil, Nil, Nil, "SC5",aCpoBrw, , , , ,  )

	EndFilBrw( "SC5", aIndexSC5 )

Return


User Function MFATCOLR
	Local lRet:=.t.

	Private oProd, oPais, oCLiente, oMoeda
	Private aCombo := {"Porta A","Porta B"} //"Pais"###"Cliente"###"Ambos"

	lFirst:=.t.

	M->C5_DTCOLR  := SC5->C5_DTCOLR
	M->C5_HRCOLR  := SC5->C5_HRCOLR
	M->C5_PORTA   := SC5->C5_PORTA
	M->C5_PLACA   := SC5->C5_PLACA

	Begin Sequence
		If !TelaGets()
			lRet:=.f.
			lFirst:=.f.
			break
		EndIf

		If lRet
			SC5->(RecLock("SC5",.F.))
			SC5->C5_DTCOLR  := M->C5_DTCOLR
			SC5->C5_HRCOLR  := M->C5_HRCOLR
			SC5->C5_PORTA   := M->C5_PORTA
			SC5->C5_PLACA   := M->C5_PLACA
			SC5->(MsUnlock())

			U_GrvLogPd( SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Retirada da Coleta", "Coleta Retirada em  "+dToc(M->C5_DTCOLR)+" as "+M->C5_HRCOLR+" Placa: "+Trans(M->C5_PLACA,'@R !!!-9999') )

			break
		Endif
	End Sequence

	Return


	/*
	Funcao      : TelaGets.
	Parametros  : Nenhum.
	Retorno     : .t./.f.
	Objetivos   : Tela para digitação dos filtros.
	Autor       : Jeferson Barros Jr.
	Data/Hora   : 14/09/04 10:18.
	Revisao     :
	Obs.        :
	*/
	*---------------------*
Static Function TelaGets()
	*---------------------*
	Local lRet:=.f.
	Local oDlg
	Local bOk :={|| lRet:=.t., oDlg:End()},;
	bCancel:= {|| oDlg:End()}


	If !lFirst
		lFirst:=.f.
		Return .f.
	Endif

	Begin Sequence

		Define MsDialog oDlg Title "Registro de Coletas" From 0,0 To 195,368 Of oMainWnd Pixel //"Aprovação de Preços - Filtros"
		@ 15,004 To 095,182 LABEL "Informacoes"  Pixel //"Parâmetros Iniciais"

		@ 27,015 Say AvSx3("C5_DTCOLR",AV_TITULO) Pixel Of oDlg
		@ 27,050 MsGet M->C5_DTCOLR Picture "@D";
		Size 045,08;
		Valid(!Empty(M->C5_DTCOLR)) Pixel Of oDlg


		@ 39,015 Say AvSx3("C5_HRCOLR",AV_TITULO) Pixel Of oDlg
		@ 39,050 MsGet M->C5_HRCOLR Picture AvSx3("C5_HRCOLR",AV_PICTURE);
		Size 045,08;
		Valid(!Empty(M->C5_HRCOLR)) Pixel Of oDlg

		@ 51,015 Say AvSx3("C5_PORTA",AV_TITULO) Pixel Of oDlg
		@ 51,050 Combobox M->C5_PORTA ITEMS aCombo;
		Size 80,8 ;
		Pixel Of oDlg

		@ 63,015 Say AvSx3("C5_PLACA",AV_TITULO) Pixel Of oDlg
		@ 63,050 MsGet M->C5_PLACA Picture AvSx3("C5_PLACA",AV_PICTURE);
		Size 045,08;
		Valid(!Empty(M->C5_PLACA)) Pixel Of oDlg

		Activate MsDialog oDlg On Init EnChoiceBar(oDlg,bOk,bCancel) Centered

	End Sequence

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InfFilt   ºAutor  ³Leandro Duarte      º Data ³  02/25/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Informa o conteudo do registro com o Filtro                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p10 e p11                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function InfFilt()
	Local cFilt		:= '"Filtro Utilizado "+CHR(10)+"'+cFiltro+'"'
	Local cNFilt	:= 'Filtro Comparado'+CRLF+' C5_TPFRETE == '+SC5->C5_TPFRETE+CRLF+'C5_X_CANC == '+SC5->C5_X_CANC+CRLF+'C5_X_REP == '+SC5->C5_X_REP+CRLF
	cNFilt	+= 'C5_PVC == '+SC5->C5_PVC+CRLF+'C5_LIBEROK == '+SC5->C5_LIBEROK+CRLF+'C5_NOTA=='+SC5->C5_NOTA+CRLF+'C5_BLQ== '+SC5->C5_BLQ+CRLF
	cNFilt	+= 'C5_XENTREG == '+DTOC(SC5->C5_XENTREG)+CRLF+'C5_CONDPAG == '+SC5->C5_CONDPAG+CRLF
	cNFilt	+= ' C5_REIMP == '+cValToChar(SC5->C5_REIMP)+CRLF+'C5_SOLCOL == '+dtoc(SC5->C5_SOLCOL)
	cFilt := STRTRAN(UPPER(cFilt),'.AND.','"+CHR(10)+"')
	cFilt := &(cFilt)
	AVISO('INFORMAÇÃO DO FILTRO',cFilt+CRLF+CRLF+cNFilt,{"OK"})
Return()

STATIC FUNCTION LIMPA()
	SLEEP(500)
	EndFilBrw( "SC5", aIndexSC5 )
RETURN()

STATIC FUNCTION VOLTA()
	SLEEP(500)
	Eval( bFilBrow )
RETURN()
