#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AFAT010   ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³16/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Tradicional ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Cancelar pedido de venda
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A410CANC(cAlias,nReg,nOpc)

Local aArea    := GetArea()
Local lValido  := .F.
Local lContinua:= .T.

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A410CANC" , __cUserID )

Private _cMotDoCan := space( len( SZ4->Z4_MOTIVO ) )
Private _cTpMotivo := space(06)
Private _aUser := pswret()

if SC5->C5_X_CANC == "C"
	lContinua := .F.
endif

dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6")+SC5->C5_NUM)

While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM )
	If SC6->C6_BLQ == "R "
		lContinua := .F.
	Endif
	dbSelectArea("SC6")
	dbSkip()
EndDo

If lContinua = .F.
	APMSGINFO("Pedido Ja está Cancelado ou ja eliminado residuo!")
Endif


If SoftLock(cAlias) .and. lContinua
	
	//Visualização padrão do protheus
	//Retorno 1 significa que foi clicado em OK
	//Se foi clicado OK Continuar com o cancelamento
	If a410Visual(cAlias,nReg,nOpc)==1
		
		If lContinua
			lContinua := A410ChkPed()
		EndIf
		
		If lContinua
			lContinua := A410CanOk()
		EndIf
		
		If lContinua
			Begin Transaction
			//*************************
			//³ Eliminacao de residuo *
			//*************************
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC5->C5_NUM)
			CMVEECFAT := SuperGetMv("MV_EECFAT",," ") 
			While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
				lValido  := .T.
				If lValido .And. !Empty(SC5->C5_PEDEXP) .And. CMVEECFAT // Integracao SIGAEEC
					If FindFunction("EECZERASALDO")
						lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.)
					Else
						lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.)
					EndIf
				EndIf
				If lValido
					MaResDoFat(,.T.,.F.)
				EndIf
				dbSelectArea("SC6")
				dbSkip()
			EndDo
			SC6->(MaLiberOk({SC5->C5_NUM},.T.))
			End Transaction
			
			RecLock("SC5")
			SC5->C5_X_CANC  := "C"
			SC5->C5_X_MOTCA := _cTpMotivo
			SC5->C5_CONTRA := SPACE(LEN(SC5->C5_CONTRA))

			MsUnLock()
			//Limpando o Empenho do poder de terceiro para utilizar a nota em outro pedido Luiz
			//	if SC5->C5_TIPO == "B"
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC5->C5_NUM)
			While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
				If !Empty(SC6->C6_NFORI)
					
					dbSelectArea("SB6")
					dbSetOrder(5)
					MsSeek(xFilial("SB6")+SC6->C6_PRODUTO+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NFORI+SC6->C6_SERIORI)
					
					While ( !Eof() .And. SC6->C6_PRODUTO == SB6->B6_PRODUTO .AND. SB6->B6_DOC = SC6->C6_NFORI .AND. SC6->C6_SERIORI = SB6->B6_SERIE )
						IF SB6->B6_ATEND <> "S"
							RecLock("SB6")
							IF  SB6->B6_QULIB > SC6->C6_QTDVEN
								SB6->B6_QULIB  -= SC6->C6_QTDVEN
							ELSE
								SB6->B6_QULIB  := 0
							ENDIF
							MsUnLock()
						ENDIF
						dbSelectArea("SB6")
						dbSkip()
					ENDDO
					
				endif
				RecLock("SC6")
				SC6->C6_NFORI  := ''
				SC6->C6_SERIORI := ''
				MsUnLock()
				dbSelectArea("SC6")
				dbSkip()
			EndDo
			//	endif
			
			//Gravar o LOG
			U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Cancelamento",_cMotDoCan)
		EndIf
	EndIf
EndIf
MsUnLockAll()
RestArea(aArea)
Return


/************************************************************************************
Tela para digitar o motivo do cancelamento e confirmar o cancelamento do pedido.*
************************************************************************************/
Static Function A410CanOk()
Local _lRet := .F.
Local _oDlg		// Tela
Local nDic := 0

//Declaração de cVariable dos componentes
Private _cMotivo  := Space( len( SZ4->Z4_MOTIVO ) )
Private _cTpMot   := Space( 6 )
Private _aItems   := {}
Private aSX5Z4   := FWGetSX5("Z4")
//Declaração de Variaveis Private dos Objetos
SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oSay5","_oTpMot","_oMotivo","_oSBtnOk","_oSBtnCancel")

//SX5->( dbSeek( xFilial( "SX5" ) + "Z4" ) )
for nDic := 2 to len(aSX5Z4)
//Do While .not. SX5->( eof() ) .and. SX5->X5_TABELA == "Z4"
	aadd( _aItems, aSX5Z4[nDic][3] + "-" + aSX5Z4[nDic][4] )
Next nDic

//Definicao do Dialog e todos os seus componentes.
_oDlg      := MSDialog():New( 089,232,374,1033,"Cancelamento de Pedido",,,.F.,,,,,,.T.,,,.T. )
_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
_oSay4     := TSay():New( 056,010,{|| _aUser[1][2] },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
_oSay5     := TSay():New( 080,010,{||"Motivo do Cancelamento:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
_oSay3     := TSay():New( 095,010,{||"Complemento do Motivo :"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)

//_oTpMot    := TGet():New( 076,090,{|u| If(PCount()>0,cTpMot:=u,_cTpMot)},_oDlg,030,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cTpMot",,)
_oTpMot    := tComboBox():New(076,090,{|u|if(PCount()>0,_cTpMot:=u,_cTpMot)},_aItems,140,010,_oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,,"_cTpMot")

_oMotivo   := TGet():New( 094,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
_oSBtnOk   := tButton():New( 114,320,"Ok",_oDlg,{|| iif( _ChkMot(_cTpMot,_cMotivo),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
_oSBtnCanc := tButton():New( 114,360,"Cancelar",_oDlg,{||_oDlg:End()},30,10,,,,.T.)

_oDlg:Activate(,,,.T.)

if _lRet
	//Atualizar variavel private declarada na função anterior para gravar o motivo do cancelamento
	//Posteriormente ver uma maneira mais adequada para fazer isto
	_cMotDoCan := _cMotivo
	_cTpMotivo := Substr( _cTpMot, 1, AT("-",_cTpMot)-1 )
	
endif

Return( _lRet )

/*
Validar se o motivo foi digitado
*/
Static Function _ChkMot(_cTpMot,_cMotivo)
if Empty( _cTpMot )
	APMSGINFO( "O motivo do cancelamento deve ser informado!" )
	Return( .F. )
endif
if Empty( _cMotivo )
	APMSGINFO( "O complemento do motivo do cancelamento deve ser informado!" )
	Return( .F. )
endif
Return( .T. )


/************************************************
Validações gerais para poder cancelar um pedido *
************************************************/
Static Function A410ChkPed()
Local _lRet     := .T.
Local lLiber    := .F.
Local lFaturado := .F.
Local lContrat  := .F.
Local _nReg     := SC6->( recno() )

SC6->( dbSeek( SC5->C5_NUM ) )
SC6->( dbSetOrder(1) )
SC6->( MsSeek(xFilial("SC6")+SC5->C5_NUM) )
Do While ( !SC6->(Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM )
	
	If ( SC6->C6_QTDEMP > 0 )
		lLiber := .T.
	EndIf
	
	If ( SC6->C6_QTDENT > 0 ) .Or. ( SC5->C5_TIPO $ "CIP" .And. !Empty(SC6->C6_NOTA) )
		lFaturado :=  .T.
	EndIf
	
	If !Empty(SC6->C6_CONTRAT) .And. !lContrat
		dbSelectArea("ADB")
		dbSetOrder(1)
		if MsSeek(xFilial("ADB")+SC6->C6_CONTRAT+SC6->C6_ITEMCON)
			If ADB->ADB_QTDEMP > 0 .And. ADB->ADB_PEDCOB == (cArqQry)->C6_NUM
				lContrat := .T.
			EndIf
		EndIf
		dbSelectArea("SC6")
	EndIf
	
	SC6->( dbSkip() )
	
EndDo

If ( lFaturado )
	MsgAlert( "Pedido de Venda Já Possui Faturamento." )
	_lRet := .F.
EndIf
If ( lLiber )
	MsgAlert( "Pedido Possui Itens Liberados." )
	_lRet := .F.
EndIf
If ( lContrat )
	Help(" ",1,"A410CTRPAR")
	_lRet := .F.
EndIf

SC6->( dbgoto( _nReg ) )
Return( _lRet )

/*
*/
