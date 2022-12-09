#include "rwmake.ch"

User Function RESTA98()

Processa({|| CUSTO()},"Atualizando Estruturas...")
Return

Static Function CUSTO()


_cArquivo	:=	cGetFile("Arquivos Dbase|*.dbf", OemToAnsi("Selecione o Arquivo a Importar"),,,.t.)

_nQtde		:=	Len(_cArquivo)

//----> PROCESSA APENAS SE O ARQUIVO FOR SELECIONADO
If _nQtde > 0
	_cNome		:=	""
	
	For x := _nQtde to 1 Step -1
		If Subs(_cArquivo,x,1) = "\"
			Exit
		Endif
		_cNome := Subs(_cArquivo,x,1) + _cNome
	Next
	
	_cStartPath := GetSrvProfString("StartPath","")
	_cStartPath := StrTran(_cStartPath,"/","\")
	_cStartPath +=If(Right(_cStartPath,1)=="\","","\")
	
	//----> COPIA O ARQUIVO DE TRABALHO DA MAQUINA PARA O SERVIDOR
	CpyT2S(_cArquivo,_cStartPath)
	
	_cArquivo	:= _cStartPath+_cNome
	
	
	dbUseArea(.t.,"DBFCDX",_cArquivo ,"PRC",.f.,.f.)
	
	
	dbSelectArea("PRC")
	dbGoTop()
	ProcRegua(RecCount())
	
	While Eof() == .f.
		
		IncProc("Processando Atualizacao de Estruturas..")
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		If dbSeek(xFilial("SG1")+PRC->G1_COD,.F.)
			
            While Eof() == .f. .and. SG1->G1_COD == PRC->G1_COD
            
                RecLock("SG1",.f.)
                DbDelete()
                MsUnlock()

                dbSkip()
            EndDo    
		EndIf
		
		
		dbSelectArea("PRC")
		dbSkip()
	EndDo
Else
	MsgBox("Nenhum arquivo selecionado para importar","Arquivo nao Selecionado","Stop")
EndIf

Return
