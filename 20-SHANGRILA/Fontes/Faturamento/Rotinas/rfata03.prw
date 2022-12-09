#include "rwmake.ch"

User Function RFATA03()

Processa({|| PRECO()},"Importação Tabela de Preço")
Return

Static Function PRECO()

Local _cPerg   	:=	"FATA03"
Local _aRegs   	:=	{}
Local _lCabec	:=	.t.
Local _nItens	:=	0

AAdd(_aRegs,{_cPerg,"01","Codigo Tabela      ?","Caminho do Arquivo ?"       ,"Caminho do Arquivo ?"       ,"mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
		If dbSeek(xFilial("SB1")+PRC->PRODUTO,.F.)
			
			//----> TABELA INTERNA
			If mv_par02 == 1
				If SB1->B1_TAB_IN$"S"
					RecLock("SB1",.f.)
					SB1->B1_PRV1	:=	PRC->PRBASE
					MsUnLock()
					
					dbSelectArea("DA1")
					dbSetOrder(1)
					If dbSeek(xFilial("DA1")+mv_par01+PRC->PRODUTO,.F.)
						
						RecLock("DA1",.f.)
						//DA1->DA1_FILIAL		:=	XFILIAL("DA1")
						//DA1->DA1_ITEM		:=	StrZero(_nItens,4)
						//DA1->DA1_CODPRO		:=	PRC->PRODUTO
						DA1->DA1_PRCVEN		:=	PRC->PRBASE
						//DA1->DA1_MOEDA		:=  1
						//DA1->DA1_DATVIG		:=	MV_PAR03
						//DA1->DA1_CODTAB		:=	MV_PAR01
						//DA1->DA1_ATIVO		:=	'1'
						//DA1->DA1_TPOPER		:=	'4'
						//DA1->DA1_QTDLOT		:=	999999.99
						//DA1->DA1_INDLOT		:= 	'000000000999999.99'
						//DA1->DA1_DESC		:=	PRC->DESC
						MsUnLock()
					EndIf
				EndIf
				//---->TABELA EXTERNA
			ElseIf mv_par02 == 2
				If SB1->B1_TAB_EX$"S"
					RecLock("SB1",.f.)
					SB1->B1_PRV1	:=	PRC->PRBASE
					MsUnLock()
					
					
					dbSelectArea("DA1")
					dbSetOrder(1)
					If dbSeek(xFilial("DA1")+mv_par01+PRC->PRODUTO,.F.)
						
						RecLock("DA1",.f.)
						//DA1->DA1_FILIAL		:=	XFILIAL("DA1")
						//DA1->DA1_ITEM		:=	StrZero(_nItens,4)
						//DA1->DA1_CODPRO		:=	PRC->PRODUTO
						DA1->DA1_PRCVEN		:=	PRC->PRBASE
						//DA1->DA1_MOEDA		:=  1
						//DA1->DA1_DATVIG		:=	MV_PAR03
						//DA1->DA1_CODTAB		:=	MV_PAR01
						//DA1->DA1_ATIVO		:=	'1'
						//DA1->DA1_TPOPER		:=	'4'
						//DA1->DA1_QTDLOT		:=	999999.99
						//DA1->DA1_INDLOT		:= 	'000000000999999.99'
						//DA1->DA1_DESC		:=	PRC->DESC
						MsUnLock()
					EndIf
				EndIf
				//----> TODAS TABELAS
			Else
				RecLock("SB1",.f.)
				SB1->B1_PRV1	:=	PRC->PRBASE
				MsUnLock()
				
				dbSelectArea("DA1")
				dbSetOrder(1)
				If dbSeek(xFilial("DA1")+mv_par01+PRC->PRODUTO,.F.)
					
					RecLock("DA1",.f.)
					//DA1->DA1_FILIAL		:=	XFILIAL("DA1")
					//DA1->DA1_ITEM		:=	StrZero(_nItens,4)
					//DA1->DA1_CODPRO		:=	PRC->PRODUTO
					DA1->DA1_PRCVEN		:=	PRC->PRBASE
					//DA1->DA1_MOEDA		:=  1
					//DA1->DA1_DATVIG		:=	MV_PAR03
					//DA1->DA1_CODTAB		:=	MV_PAR01
					//DA1->DA1_ATIVO		:=	'1'
					//DA1->DA1_TPOPER		:=	'4'
					//DA1->DA1_QTDLOT		:=	999999.99
					//DA1->DA1_INDLOT		:= 	'000000000999999.99'
					//DA1->DA1_DESC		:=	PRC->DESC
					MsUnLock()
				EndIf
				
			EndIf
		EndIf
		
		dbSelectArea("PRC")
		dbSkip()
	EndDo
Else
	MsgBox("Nenhum arquivo selecionado para importar","Arquivo nao Selecionado","Stop")
EndIf

Return
