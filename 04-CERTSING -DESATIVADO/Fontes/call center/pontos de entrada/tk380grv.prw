#include "protheus.ch" 

//-----------------------------------------------------------
// Rotina | tk380grv | Totvs - David       | Data | 29.10.13
// ----------------------------------------------------------
// Descr. | Ponto de Entrada no momento de finaliza��o de   
//        | grava��o das respostas e perguntas do protheus
//-----------------------------------------------------------
User Function TK380GRV
Local _aArea		:= GetArea()
Local _cFormato	:= paramixb[1]	// Formato do script
Local _aControl	:= paramixb[2]	// Array de controle com todas as perguntas e respostas
Local _aItens		:= paramixb[3] // Array com os itens a serem gravados
Local _lRet			:= paramixb[4] // Variavel de controle se ser� ou n�o gravada as informa��es
Local _cOper		:= TkOperador()// C�digo do Operador de Call Center
Local _cGrp			:= ""
Local _nI			:= 0

// Caso etenha sido confirmada a inclus�o realiza as valida��es
If _lRet
	
	//posiciona no operador e obtem o grupo padr�o de atendimento do mesmo
	DbSelectArea("SU7")
	SU7->(DbSetOrder(1))
	
	If SU7->(DbSeek(xFilial("SU7")+_cOper)) 
		_cGrp := SU7->U7_POSTO	
	EndIf
	
	//grava no scrip respondido o grupo de origem, caso n�o esteja preenchido
	If Empty(ACI->ACI_XCODGP) .AND. !Empty(_cGrp)
		RecLock("ACI",.F.)
			ACI->ACI_XCODGP	:= _cGrp
		ACI->(MsUnlock())
	Endif
EndIf         

RestArea(_aArea)

Return