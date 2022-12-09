#include "PROTHEUS.CH"

User Function MOVSAIDA()

Local   aItem   := {}
Local	_cLote 	:= ""
Private lMsErroAuto := .F.


Processa({|| CUSTO()},"BAIXA ESTOQUE KIMONO")
Return

Static Function CUSTO()


_cArquivo	:=	cGetFile("Arquivos|*.dtc", OemToAnsi("Selecione o Arquivo a Importar"),,,.t.)

_nQtde		:=	Len(_cArquivo)

//----> PROCESSA APENAS SE O ARQUIVO FOR SELECIONADO
If _nQtde > 0
	
	/*
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
	*/
	
	dbUseArea(.t.,"CTREECDX",_cArquivo ,"PRC",.f.,.f.)
	
	
	dbSelectArea("PRC")
	dbGoTop()
	ProcRegua(RecCount())
	

	While Eof() == .f.

		IncProc("Processando Baixas Estoque..")
		
		aItem   := {}
		
		dbSelectArea("SB8")
		dbSetOrder(1)
		If dbSeek(xFilial("SB8")+ALLTRIM(PRC->D3_COD),.f.)
			
			While Eof() == .f. .And. ALLTRIM(SB8->B8_PRODUTO)+ALLTRIM(SB8->B8_LOCAL) == ALLTRIM(PRC->D3_COD)+"01"
			
				If SB8->B8_SALDO < PRC->D3_QUANT
					dbSelectArea("SB8")
					dbSkip()
					Loop
				Else
					_cLote := SB8->B8_LOTECTL
					_dDtVld:= SB8->B8_DTVALID
					Exit
				EndIf
		
				dbSelectArea("SB8")
				dbSkip()
			EndDo

			dbSelectArea("PRC")
			
			If _cLote <> ''
			
				aadd(aItem,{"D3_FILIAL" ,xFilial("SD3") ,NIL})
				aadd(aItem,{"D3_DOC"    ,PRC->D3_DOC	,Nil})
				aadd(aItem,{"D3_TM"     ,'504'      	,Nil})
				aadd(aItem,{"D3_EMISSAO",PRC->D3_EMISSAO,Nil})
				aadd(aItem,{"D3_COD"    ,PRC->D3_COD    ,Nil})
				aadd(aItem,{"D3_UM"     ,Posicione("SB1",1,xFilial("SB1")+PRC->D3_COD,"B1_UM")    ,Nil})
				aadd(aItem,{"D3_OBS1"   ,PRC->D3_OBS1 	,Nil})
				aadd(aItem,{"D3_QUANT"  ,PRC->D3_QUANT  ,Nil})
				aadd(aItem,{"D3_REVISOR",1				,Nil})
				aadd(aItem,{"D3_LOTECTL",_cLote			,Nil})
				aadd(aItem,{"D3_DTVALID",_dDtVld		,Nil})
				aadd(aItem,{"D3_LOCAL"  ,'01' 			,Nil})
				
				
				MSExecAuto({|x,y|MATA240(x,y)},aItem, 3)
				
				If lMsErroAuto
					ApMsgAlert("Erro")
					MostraErro()
				Endif
			Else
			     MsgAlert("O produto "+ALLTRIM(PRC->D3_COD)+" nao possui saldo em estoque para realizar a baixa. Favor verificar")
			EndIf
			
			_cLote := ""
			
		EndIf
		
		dbSelectArea("PRC")
		dbSkip()
	EndDo
Else
	MsgBox("Nenhum arquivo selecionado para importar","Arquivo nao Selecionado","Stop")
EndIf

Return
