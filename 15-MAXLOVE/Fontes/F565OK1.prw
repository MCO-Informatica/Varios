#include "protheus.ch"


User Function F565OK1()

Local _lRet := .t.


//----> VERIFICA SE O FORNECEDOR ORIGEM ESTA DIFERENTE DO FORNECEDOR DESTINO E AVISA
If cFornDe <> cFornece
	If !MsgYesNo("Tem certeza que deseja gerar o(s) título(s) para o fornecedor "+cFornece+" "+Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NREDUZ")+"?","Atenção")
		_lRet:= .f.
	EndIf
EndIf


Return(_lRet)