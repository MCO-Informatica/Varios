#include "rwmake.ch"

User Function RFATA06()

Processa({|| CADASTRO()},"Ajuste Cadastro SB1")
Return

Static Function CADASTRO()

Local _cPerg   	:=	"FATA03"
Local _aRegs   	:=	{}
Local _lCabec	:=	.t.
Local _nItens	:=	0

AAdd(_aRegs,{_cPerg,"01","Caminho do Arquivo ?","Caminho do Arquivo ?"       ,"Caminho do Arquivo ?"       ,"mv_ch1","G",60,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Tabela	         ?","Tabela				?"       ,"Tabela			  ?"       ,"mv_ch2","N",01,0,3,"C","","mv_par02","Interno","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(_aRegs,{_cPerg,"05","Caminho do Arquivo ?","Caminho do Arquivo ?"       ,"Caminho do Arquivo ?"       ,"mv_ch5","C",60,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,_cPerg)

If !Pergunte(_cPerg,.t.)
	Return()
EndIf


_cArquivo	:=	cGetFile("Arquivos Dbase Ctree|*.dtc", OemToAnsi("Selecione o Arquivo a Importar"),,,.t.)

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
	
	dbUseArea(.t.,"CTREECDX",_cArquivo ,"PRC",.f.,.f.)
	
	
	dbSelectArea("PRC")
	dbGoTop()
	ProcRegua(RecCount())
	
	While Eof() == .f.
		
		IncProc("Processando Atualizacao de Tabela de Preco...")
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+PRC->B1_COD,.F.)
			
			RecLock("SB1",.f.)
			SB1->B1_QE		:=	PRC->B1_QE
			SB1->B1_EMIN	:=	PRC->B1_EMIN
			SB1->B1_ESTSEG	:=	PRC->B1_ESTSEG
			SB1->B1_LE		:=	PRC->B1_LE
			SB1->B1_LM		:=	PRC->B1_LM
			SB1->B1_EMAX	:=	PRC->B1_EMAX
			MsUnLock()
					
		EndIf
		
		dbSelectArea("PRC")
		dbSkip()
	EndDo
Else
	MsgBox("Nenhum arquivo selecionado para importar","Arquivo nao Selecionado","Stop")
EndIf

Return
