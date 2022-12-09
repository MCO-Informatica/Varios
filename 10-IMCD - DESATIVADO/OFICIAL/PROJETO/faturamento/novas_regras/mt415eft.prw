#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"

User Function MT415EFT ()

	Local aArea := GetArea()
	Local lRetX := .T.
	Local lConf := .T.
	Local cOrcamento := SCJ->CJ_NUM
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario

	Local _lRet := .T.
	Local _oDlg		// Tela
	Local aSX5Z4 := {}
	Local nDic   := 0

	Private _cMotDoCan := space( len( SZ4->Z4_MOTIVO ) )
	Private _cTpMotivo := space(06)
	Private _aUser := pswret()
	Private _cMotivo  := Space( len( SZ4->Z4_MOTIVO ) )
	Private _cTpMot   := Space( 6 )
	Private _cGerApv  := Space (30)
	Private _cGerente := Space( 30)
	Private _aItems   := {}
	//Declaração de Variaveis Private dos Objetos
	SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oSay5","_oTpMot","_oMotivo","_oSBtnOk","_oSBtnCancel", "_oGerente")
	
	Public  cEmail 
	Public  cAssunto  
	Public  cArq
	Public  BlqMg := .F.

	If Paramixb[1] == 1
		If  SCJ->CJ_XVRMARG < SCJ->CJ_XMARGPR

			If MSGYESNO("Margem inferior a minima permitida, deseja continuar?","Alterações")
				RECLOCK("SCJ",.F.)
				SCJ->CJ_XAPROV := UsrRetName(cCodUser)
				MSUNLOCK()

				// ALTERADO POR SANDRA NISHIDA
				if Select("RMIN") > 0
					RMIN->( dbCloseArea() )
				EndIf
				/*
				cQueryP := "SELECT A3_NOME FJUNROM "+RetSqlName("SA3")+" SA3 WHERE SA3.D_E_L_E_T_ <> '*' "
				cQueryP += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND A3_NOME <> ' ' AND A3_MSBLQL = '2' GROUP BY A3_NOME  "
				*/
				cQueryP := " SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
				cQueryP += " WHERE A3_CARGO = '000007' "
				cQueryP += " AND A3_FILIAL = '"+xFilial("SA3")+"' "
				cQueryP += " AND A3_NOME <> ' ' "
				cQueryP += " AND A3_MSBLQL <> '1' "
				cQueryP += " AND D_E_L_E_T_ <> '*' "
				cQueryP += " GROUP BY A3_NOME  "

				TCQUERY cQueryP NEW ALIAS "RMIN"


				DbSelectArea("RMIN")
				DbGotop()

				While !Eof()
					aadd( _aItems, Alltrim(RMIN->A3_NOME) )
					RMIN->( dbSkip() )
				EndDo

				//Definicao do Dialog e todos os seus componentes.
				_oDlg      := MSDialog():New( 089,232,374,1033,"Aprovação do orçamento",,,.F.,,,,,,.T.,,,.T. )
				_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
				_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
				_oSay4     := TSay():New( 056,010,{|| _aUser[1][2] },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
				_oSay5     := TSay():New( 080,010,{||"Gerente Aprovador:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)

				_oGerApv   := tComboBox():New(076,090,{|u|if(PCount()>0,_cGerApv:=u,_cGerApv)},_aItems,140,010,_oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,,"_cGerApv")
				_oSBtnOk   := tButton():New( 114,320,"Ok",_oDlg,{|| iif( _ChGerApv(_cGerApv),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
				_oSBtnCanc := tButton():New( 114,360,"Cancelar",_oDlg,{||_oDlg:End(),_lRet:=.F.},30,10,,,,.T.)

				_oDlg:Activate(,,,.T.)
				if _lRet

					_cGerente := _cGerApv
					RECLOCK("SCJ",.F.)
					SCJ->CJ_XGERAPR := _cGerente
					MSUNLOCK()
				endif
			Else
				
				aSX5Z4 := FWGETSX5("Z4")
				
				aadd( _aItems, space( len( aSX5Z4[1][4] ) + len( aSX5Z4[1][4] ) + 1 ) )

				//SX5->( dbSeek( xFilial( "SX5" ) + "Z4" ) )
				//Do While .not. SX5->( eof() ) .and. SX5->X5_TABELA == "Z4"
				for nDic := 1 to len(aSX5Z4)
					aadd( _aItems, aSX5Z4[1][3] + "-" + aSX5Z4[1][4] )
				next nDic

				//Definicao do Dialog e todos os seus componentes.
				_oDlg      := MSDialog():New( 089,232,374,1033,"Rejeição do orçamento",,,.F.,,,,,,.T.,,,.T. )
				_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
				_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
				_oSay4     := TSay():New( 056,010,{|| _aUser[1][2] },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
				_oSay5     := TSay():New( 080,010,{||"Motivo da Rejeição:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
				_oSay3     := TSay():New( 095,010,{||"Complemento do Motivo :"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)

				_oTpMot    := tComboBox():New(076,090,{|u|if(PCount()>0,_cTpMot:=u,_cTpMot)},_aItems,140,010,_oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,,"_cTpMot")
				_oMotivo   := TGet():New( 094,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
				_oSBtnOk   := tButton():New( 114,320,"Ok",_oDlg,{|| iif( _ChkMot(_cTpMot,_cMotivo),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
				_oSBtnCanc := tButton():New( 114,360,"Cancelar",_oDlg,{||_oDlg:End(),_lRet:=.F.},30,10,,,,.T.)

				_oDlg:Activate(,,,.T.)

				if _lRet
					//Atualizar variavel private declarada na função anterior para gravar o motivo do cancelamento
					//Posteriormente ver uma maneira mais adequada para fazer isto
					cMotDoCan := _cMotivo
					cTpMotivo := Substr( _cTpMot, 1, AT("-",_cTpMot)-1 )
					RECLOCK("SCJ",.F.)
					SCJ->CJ_XMOTREJ := ALLTRIM(cTpMotivo ) + " - "+ ALLTRIM(cMotDoCan)
					SCJ->CJ_XAPROV := UsrRetName(cCodUser)
					SCJ->CJ_STATUS := "C"
					MSUNLOCK()
					_lRet:=.F.
				endif
			Endif
		endif

	Endif

Return _lRet

/*
Validar se o motivo foi digitado
*/
Static Function _ChkMot(_cTpMot,_cMotivo)
	if Empty( _cTpMot )
		APMSGINFO( "O motivo da rejeição deve ser informado!" )
		Return( .F. )
	endif
	if Empty( _cMotivo )
		APMSGINFO( "O complemento da rejeição deve ser informado!" )
		Return( .F. )
	endif

Return( .T. )

/*
Validar se o gerente aprovador foi digitado
*/
Static Function _ChGerApv(_cGerApv)
	if Empty(_cGerApv )
		APMSGINFO( "O gerente aprovador deve ser informado!" )
		Return( .F. )
	endif

Return( .T. )
