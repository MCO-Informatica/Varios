#INCLUDE "protheus.ch"

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | M410ALOK.PRW         | AUTOR | rdSolution   | DATA | 09/02/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - M410ALOK                                     |//
//|           | Este Ponto tem como objetivo pedir uma senha para alteração     |//
//|           | do pedido de venda.                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function M410ALOK()

Local oDlg
Local oBut1
Local oBut2

Local _cPass := Space(06)
Local _lRet  := .F.

Private oPass    := Nil
Private _cValUsr := '"' + SuperGetMV("MV_X_USRAP") + '""

Public _eMailAprov := ""

DEFINE MSDIALOG oDlg FROM 050,100 TO 160,430 TITLE OemToAnsi("Alteração do Pedido") PIXEL

@ 005,002 TO 035,165 LABEL "Senha de Autorização"   OF oDlg PIXEL
@ 015,005 MSGET oPass VAR _cPass SIZE 060,010 Of oDlg PIXEL PASSWORD

@ 038,070 BUTTON oBut1 PROMPT ("&Ok")      SIZE 044,012 Of oDlg PIXEl Action (_lRet := _VldPsw(_cPass) , IIf(_lRet,oDlg:End(),"") )
@ 038,120 BUTTON oBut2 PROMPT ("&Cancela") SIZE 044,012 Of oDlg PIXEl Action (_lRet := .F. , oDlg:End() )

ACTIVATE MSDIALOG oDlg

Return(_lRet)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| FUNÇÃO    | _VLDPSW()            | AUTOR | rdSolution   | DATA | 09/02/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Função - _VLDPSW()                                              |//
//|           | Esta função tem como objetivo, validar a senha digitada,        |//
//|           | caso a senha exista, identificar o codigo do usuario e          |//
//|           | verificar se o mesmo consta no parametro MC_X_USRAP.            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function _VldPsw(_cPass)

Local _lRet    := .F.
Local _aRet    := {}
Local _cCodUsr := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se a Senha ja existe no Arquivo de Senhas          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//PswOrder(3)

//If PswSeek(_cPass)

	//_aRet     := PswRet(1)
	//_cCodUsr  := _aRet[1][1]
	_cCodUsr  := __CuserID
	PswOrder(1)
    PswSeek(__CuserID)
    _aRet     := PswRet(1)

	If (Alltrim(_cCodUsr) $ _cValUsr)
		_eMailAprov := _aRet[1][14]
		_lRet       := .T.
	Endif	
	
//Endif	

If !_lRet
	msgAlert("Senha de Usuario não Autorizado...","MATA410")
	_eMailAprov := ""
	oPass:SetFocus()
Endif	

Return(_lRet)

