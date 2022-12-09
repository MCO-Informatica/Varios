#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "SET.CH"

User Function M415CANC()

	Local nOpcao := 1    
	Local aArea := GetArea() 
	Local lRetX := .T. 
	Local lConf := .T.
	Local cOrcamento := SCJ->CJ_NUM    
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario                                 

	Local _lRet := .F. 
	Local _oDlg		// Tela
	Local aSX5 := {}
	Local i := 0

	Private _cMotDoCan := space( len( SZ4->Z4_MOTIVO ) )
	//Private _cTpMotivo := space( len( SX5->X5_CHAVE ) )
	Private _aUser := pswret()
	Private _cMotivo  := Space( len( SZ4->Z4_MOTIVO ) )
	Private _cTpMot   := Space( 6 )
	Private _aItems   := {}
	//Declaração de Variaveis Private dos Objetos
	SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oSay5","_oTpMot","_oMotivo","_oSBtnOk","_oSBtnCancel")

	aSX5 := FWGetSX5("Z4")

	aadd( _aItems, space( len( aSX5[1][4] ) + len( aSX5[1][4] ) + 1 ) )

	//SX5->( dbSeek( xFilial( "SX5" ) + "Z4" ) )
	//Do While .not. SX5->( eof() ) .and. SX5->X5_TABELA == "Z4"
	for i := 1 to Len(aSX5) 
		aadd( _aItems, aSX5[1][3] + "-" + aSX5[1][4] )

	next i

	//Definicao do Dialog e todos os seus componentes.
	_oDlg      := MSDialog():New( 089,232,374,1033,"Cancelamento do orçamento",,,.F.,,,,,,.T.,,,.T. )
	_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
	_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	_oSay4     := TSay():New( 056,010,{|| _aUser[1][2] },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
	_oSay5     := TSay():New( 080,010,{||"Motivo do cancelamento:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
	_oSay3     := TSay():New( 095,010,{||"Complemento do Motivo :"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)

	_oTpMot    := tComboBox():New(076,090,{|u|if(PCount()>0,_cTpMot:=u,_cTpMot)},_aItems,140,010,_oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,,"_cTpMot")
	_oMotivo   := TGet():New( 094,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
	_oSBtnOk   := tButton():New( 114,320,"Ok",_oDlg,{|| iif( _ChkMot(_cTpMot,_cMotivo),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
	_oSBtnCanc := tButton():New( 114,360,"Cancelar",_oDlg,{||_oDlg:End()},30,10,,,,.T.)

	_oDlg:Activate(,,,.T.)

	if _lRet
		//Atualizar variavel private declarada na função anterior para gravar o motivo do cancelamento
		//Posteriormente ver uma maneira mais adequada para fazer isto
		cMotDoCan := _cMotivo
		cTpMotivo := Substr( _cTpMot, 1, AT("-",_cTpMot)-1 )
		RECLOCK("SCJ",.F.)
		SCJ->CJ_XMOTREJ := ALLTRIM(cTpMotivo ) + " - "+ ALLTRIM(cMotDoCan)  
		SCJ->CJ_XAPROV := UsrRetName(cCodUser) 
		MSUNLOCK()   			 
		lRetX := .F.  

	else 
		nOpcao := 2		   
	endif   
Return nOpcao

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

