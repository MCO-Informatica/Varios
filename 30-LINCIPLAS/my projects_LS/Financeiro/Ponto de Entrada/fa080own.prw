#include "rwmake.ch"

// Programa: fa080own
// Autor...: Alexandre Dalpiaz
// Data....: 15/10/10
// Fun��o..: PE na confirma��o do cancelamento de baixa de t�tulos a pagar

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fa080own
///////////////////////
Local _lRet   := .t.
Local _aAlias := GetArea()
If SE5->E5_DATA <> dDataBase
	If upper(left(GetMv('LS_CANCBAI'),1)) == 'N'
		_lRet := .f.
		MsgBox('Data base do sistema (' + dtoc(dDataBase) + ') diferente da data da baixa do t�tulo(' + dtoc(SE5->E5_DATA) + ')','ATEN��O!!!','STOP')
	Else
		_lRet := MsgBox('Data base do sistema (' + dtoc(dDataBase) + ') diferente da data da baixa do t�tulo(' + dtoc(SE5->E5_DATA) + ').' + _cEnter + 'Confirma cancelamento da baixa?','ATEN��O!!!','YESNO')
	EndIf
EndIf

If _lRet .and. SE5->E5_LA == 'S '
	_lRet := .f.
	_cMotivo := space(30)
	_nCont := 0
	@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Solicita��o de Descontabiliza��o"
	@ 010,005 Say 'Baixa de t�tulo n�o pode ser cancelada pois j� foi contabilizada.'
	@ 020,005 Say 'Enviar email para o Depto de Contabilidade solicitando libera��o para cancelamento da baixa?'
	@ 040,005 Say 'Motivo:'
	@ 040,050 Get _cMotivo
	@ 090,050 BMPBUTTON TYPE 01 ACTION ( _nCont := 1, oDlg1:End() )
	@ 090,150 BMPBUTTON TYPE 02 ACTION ( _nCont := 2, oDlg1:End() )
	
	Activate Dialog oDlg1 Centered Valid _nCont > 0
	
	If _nCont == 2
		
		_cTexto := 'Solicita��o de descontabiliza��o CANCELADA.' + chr(13) + chr(13)
		_cTexto += 'N�o ser� enviado email para o Depto de Contabilidade'
		MsgBox(_cTexto,'ATEN��O!!!','INFO')
		
	Else
		
		_aAlias := GetArea()
		RecLock('ZZY',.t.)
		ZZY->ZZY_FILIAL := SE5->E5_FILIAL
		ZZY->ZZY_MSFIL  := SE5->E5_FILIAL
		ZZY->ZZY_TPMOV  := '3'
		ZZY->ZZY_DOCTO  := SE5->E5_NUMERO
		ZZY->ZZY_SERIE  := SE5->E5_PREFIXO
		ZZY->ZZY_VALOR  := SE5->E5_VALOR
		ZZY->ZZY_DTDIG  := SE5->E5_DATA
		ZZY->ZZY_DTCONT := SE5->E5_DTDISPO
		ZZY->ZZY_CLIFOR := SE5->E5_CLIFOR
		ZZY->ZZY_LOJA   := SE5->E5_LOJA
		ZZY->ZZY_DATSOL := date()
		ZZY->ZZY_EMAIL  := Pswret()[1,14]
		ZZY->ZZY_USER   := cUserName
		ZZY->ZZY_MOTIVO := _cMotivo
		MsUnLock()
		RestArea(_aAlias)
		
	EndIf
EndIf
RestArea(_aAlias)
Return(_lRet)
