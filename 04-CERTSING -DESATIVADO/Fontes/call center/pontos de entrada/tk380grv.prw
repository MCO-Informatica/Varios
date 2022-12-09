#include "protheus.ch" 

//-----------------------------------------------------------
// Rotina | tk380grv | Totvs - David       | Data | 29.10.13
// ----------------------------------------------------------
// Descr. | Ponto de Entrada no momento de finalização de   
//        | gravação das respostas e perguntas do protheus
//-----------------------------------------------------------
User Function TK380GRV
Local _aArea		:= GetArea()
Local _cFormato	:= paramixb[1]	// Formato do script
Local _aControl	:= paramixb[2]	// Array de controle com todas as perguntas e respostas
Local _aItens		:= paramixb[3] // Array com os itens a serem gravados
Local _lRet			:= paramixb[4] // Variavel de controle se será ou não gravada as informações
Local _cOper		:= TkOperador()// Código do Operador de Call Center
Local _cGrp			:= ""
Local _nI			:= 0

// Caso etenha sido confirmada a inclusão realiza as validações
If _lRet
	
	//posiciona no operador e obtem o grupo padrão de atendimento do mesmo
	DbSelectArea("SU7")
	SU7->(DbSetOrder(1))
	
	If SU7->(DbSeek(xFilial("SU7")+_cOper)) 
		_cGrp := SU7->U7_POSTO	
	EndIf
	
	//grava no scrip respondido o grupo de origem, caso não esteja preenchido
	If Empty(ACI->ACI_XCODGP) .AND. !Empty(_cGrp)
		RecLock("ACI",.F.)
			ACI->ACI_XCODGP	:= _cGrp
		ACI->(MsUnlock())
	Endif
EndIf         

RestArea(_aArea)

Return