#INCLUDE "RWMAKE.CH"

User Function RESTA04()

Processa({|lEnd| Carga()},"Ajusta Saldos Iniciais SB9 x SBJ")
Return

Static Function Carga()


Local _nQtdEst	:=	0

dbSelectArea("SBJ")
dbSetOrder(1)
dbSeek(xFilial("SBJ"),.t.)
ProcRegua(RecCount())

While Eof() == .f.

	IncProc("Processando Produto "+SBJ->BJ_COD+SBJ->BJ_LOCAL)
	
	//----> CONSIDERAR REGISTROS DE 31/12/2006
	If DTOS(SBJ->BJ_DATA) < DTOS(dDataBase)
		dbSelectArea("SBJ")
		dbSkip()
		Loop
	EndIf
	
	_cChave	:=	SBJ->(BJ_FILIAL+BJ_COD+BJ_LOCAL)
	
	While SBJ->(BJ_FILIAL+BJ_COD+BJ_LOCAL) == _cChave
	
		If DTOS(SBJ->BJ_DATA) < DTOS(dDataBase)
		
			dbSelectArea("SBJ")
			dbSkip()
			Loop
		EndIf

		_nQtdEst	+=	SBJ->BJ_QINI
		
		dbSelectArea("SBJ")
		dbSkip()

	EndDo
	
	dbSelectArea("SB9")
	dbSetOrder(1)
	If dbSeek(_cChave+dtos(dDataBase),.f.)
		
		//----> VERIFICA SE QTDE ESTA DIFERENTE ENTRE SBJ x SB9
		If SB9->B9_QINI <> _nQtdEst
			If MsgBox("Produto "+SB9->B9_COD+" está com divergência entre SB9 "+Transform(SB9->B9_QINI,"@E 999,999,999.99")+" SBJ "+Transform(_nQtdEst,"@E 999,999,999.99")+".Deseja corrigir?","Divergência SB9 x SBJ","YesNo")
				RecLock("SB9",.f.)
				SB9->B9_QINI	:=	_nQtdEst
				SB9->B9_VINI1	:=	_nQtdEst * SB9->B9_CUSTD
				MsUnLock()
			Else
				MsgBox("Produto não corrigido","Inalterado","Alert")
			EndIf
		EndIf
	EndIf
	
	_nQtdEst	:=	0
	dbSelectArea("SBJ")	
EndDo

Return
