#include "protheus.ch"              	 

//-----------------------------------------------------------
// Rotina | tk380vld | Totvs - David       | Data | 29.10.13
// ----------------------------------------------------------
// Descr. | Ponto de Entrada no momento de preenchimento das
//        | respostas de script de pesquisa
//-----------------------------------------------------------
User Function TK380VLD
Local _aArea		:= GetArea()
Local _lRet			:= .T.				// Retorno do PE
Local _cFormato	:= paramixb[1]		// Formato do question�rio
Local _nPanel		:= paramixb[2]		// Pergunta a ser respondida
Local _aControl	:= paramixb[3]		// Pergundas e Respostas preenchidas at� momento
Local _aPerguntas	:= paramixb[4]		// Pauta de perguntas e respostas
Local _nI			:= 0
Local _cCodAnt		:= ""
Local _cMsg			:= ""

// Somente realiza valida��o caso seja acionado atrav�s do ServiceDesk
If FunName() $ "TMKA503A,TMKA510A"
   
	// Regra para perguntas do tipo unica escolha
	If _aControl[_nPanel,7] == "R"

		//valida preenchimento obrigat�rio da pergunta
		_lRet := !Empty(_aControl[_nPanel,4] )
		If !_lRet
			_cMsg	:= " Pergunta de Preenchimento Obrigat�rio. Por favor, informe uma resposta! "
			
		// caso seja uma altera��o valida se grupo tem permiss�o para alterar respostas
		ElseIf !INCLUI
			_lRet := T380VLPG(M->ADE_CODIGO,M->ADE_CODCAM,_aPerguntas[_nPanel,1,1],_aControl[_nPanel,4],_aControl[_nPanel,1],_aPerguntas[_nPanel,2,_aControl[_nPanel,4],2],"R",M->ADE_GRUPO)
			If !_lRet                                                                                                                
				_cMsg	:= " Question�rio n�o pode ser alterado por este Grupo de atendimento. "
			EndIf
		EndIf
	EndIf

	// Regra para perguntas do tipo dissertativa
	If _aControl[_nPanel,7] == "M"
	
		//valida preenchimento obrigat�rio da pergunta
		_lRet := !Empty(_aControl[_nPanel,5] )
		If !_lRet
			_cMsg	:= " Pergunta de Preenchimento Obrigat�rio. Por favor, informe uma resposta! "
			
		// caso seja uma altera��o valida se grupo tem permiss�o para alterar respostas
		ElseIf !INCLUI
			_lRet := T380VLPG(M->ADE_CODIGO,M->ADE_CODCAM,_aPerguntas[_nPanel,1,1],_aControl[_nPanel,5],_aControl[_nPanel,1],_aControl[_nPanel,2],"M",M->ADE_GRUPO)
			If !_lRet
				_cMsg	:= " Question�rio n�o pode ser alterado por este Grupo de atendimento. "
			EndIf
		EndIf
	EndIf

	// Regra para perguntas do tipo multipla escolha	
	If _aControl[_nPanel,7] == "C"
		
		//valida preenchimento obrigat�rio da pergunta
		_cCodAnt := _aControl[_nPanel,1]
		_lRet 	:= _aControl[_nPanel,3]
		For _nI:=_nPanel to Len(_aControl) 
			If _lRet .or. _cCodAnt <> _aControl[_nI,1]  
				Exit	
			EndIf
			_cCodAnt := _aControl[_nI,1]
			_lRet 	:= _aControl[_nI,3]
		Next
		If !_lRet
			_cMsg	:= " Pergunta de Preenchimento Obrigat�rio. Por favor, informe uma resposta! "
		Else
			
			// caso seja uma altera��o valida se grupo tem permiss�o para alterar respostas
			_cCodAnt := _aControl[_nPanel,1]
			For _nI:=_nPanel to Len(_aControl) 
				_lRet := T380VLPG(M->ADE_CODIGO,M->ADE_CODCAM,_aPerguntas[_nPanel,1,1],_aControl[_nPanel,3],_aControl[_nPanel,1],_aControl[_nPanel,2],"C",M->ADE_GRUPO) 	
				If !_lRet .or. _cCodAnt <> _aControl[_nI,1]  
					Exit	
				EndIf
				_cCodAnt := _aControl[_nI,1]
			Next
			If !_lRet
				_cMsg	:= "Question�rio n�o pode ser alterado por este Grupo de atendimento."
			EndIf
		EndIf
	EndIf                                                                                 
	
	If !_lRet                          
		MsgStop(_cMsg)
	EndIF
EndIf

RestArea(_aArea)

Return(_lRet)
             

//-----------------------------------------------------------
// Rotina | tk380vlpg | Totvs - David       | Data | 29.10.13
// ----------------------------------------------------------
// Descr. | Rotina Estativca para valida��o de altera��o de 
//        | conteudos das respostas e se o grupo pode realizar
//        | esta altera��o
//-----------------------------------------------------------
Static Function T380VLPG(_cAtend,_cCamp,_cQuest,_cCtd,_cPerg,_cResp,_cTip,_cGrp)
Local _lRet		:= .T.
Local _cCodACI	:= ""
Local _lSeek	:= .T.
Local _cMemo	:= ""

Default _cResp	:= "0000000"

//Posiciona na pergunta para obter o grupo que a respondeu
DbSelectArea("ACI")
ACI->(DbOrderNickName("ACI_5"))
_cCodACI := ""
If ACI->(DbSeek(xFilial("ACI")+"4"+_cAtend+_cCamp+_cQuest))
	_cCodACI := ACI->ACI_CODIGO	
	
	// verifica se a pergunta foi respondida
	SUK->(DbOrderNickName("SUK_2"))
	
	_lSeek := SUK->(DbSeek(xFilial("SUK")+_cCodACI+_cPerg+_cResp))
	
	// De acordo cada tipo realiza a verifica��o se houve altera��o na resposta
	If _cTip == "C"
		_lRet := _cCtd == _lSeek
   ElseIf _cTip == "M"
   	If _lSeek
   		_cMemo	:= Msmm(SUK->UK_CODMEMO,TamSX3("UK_RESMEMO")[1])
   		_lRet 	:= Alltrim(_cCtd) == Alltrim(_cMemo)   		
   	Else
   		_lRet := .F.
   	EndIf 
   ElseIf _cTip == "R"
   	_lRet := _lSeek   
	EndIf
	
	// caso haja altera��es na resposta verifica se o grupo de origem � igual ao do operador que esta alterando o question�rio
	If !_lRet
		_lRet := _cGrp == ACI->ACI_XCODGP
	EndIf
EndIf
Return(_lRet)