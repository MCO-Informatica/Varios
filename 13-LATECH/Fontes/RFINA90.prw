/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINA90   ºAutor  ³Leandro/Ricardo/MVG º Data ³01/06/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de Registros do Sistema Formula Certa           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Healthtech                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "protheus.ch"

User Function RFINA90()

Processa({|| ATUSE1SE2()},"Importação de Registros do Sistema Fórmula Certa")
Return

Static Function ATUSE1SE2()

Local _cPerg   := "FINA90    "
Local _aRegs   :={}
Local _aEstruSE1 := {}
Local _aEstruSE2 := {}

AAdd(_aRegs,{_cPerg,"01","Caminho do Arquivo ?","Caminho do Arquivo ?"       ,"Caminho do Arquivo ?"       ,"mv_ch1","C",60,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Tipo do Arquivo ?"   ,"Tipo do Arquivo ?"          ,"Tipo do Arquivo ?"          ,"mv_ch1","N",01,0,2,"C","","mv_par02","Receber","","","","","Pagar","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.T.)


//----> ARQUIVO DO CONTAS A RECEBER
If mv_par02 == 1
	
	_cArquivo	:=	cGetFile("Arquivos Dbase|*.dbf",OemToAnsi("Selecione o Arquivo a Importar"),,,.t.)

	_nQtde		:=	Len(_cArquivo)

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

	CpyT2S(_cArquivo,_cStartPath)
	
	_cArquivo	:= _cStartPath+_cNome
	
	dbUseArea(.t.,"DBFCDXADS",_cArquivo ,"REC",.f.,.f.)
	
	dbSelectArea("REC")
	dbGoTop()
	ProcRegua(RecCount())
	
	While Eof() == .f.
		
		IncProc("Processando Registros de Contas a Receber do Sistema Fórmula Certa "+StrZero(Recno(),10))
		
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(REC->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA),.F.)
			
			RecLock("REC",.F.)
			REC->E1_PARCELA		:=	SOMA1(REC->E1_PARCELA)
			MsUnLock()
			
		EndIf
		
		//----> RECEBIMENTO EM DINHEIRO
		If Alltrim(REC->E1_TIPO) $ "R$"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
			
			//----> RECEBIMENTO EM CHEQUE PRE
		ElseIf Alltrim(REC->E1_TIPO) $"CH"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
			aadd(_aEstruSE1, {"E1_BCOCHQ",		REC->E1_BCOCHQ,		nil })
			aadd(_aEstruSE1, {"E1_AGECHQ",		REC->E1_AGECHQ,		nil })
			aadd(_aEstruSE1, {"E1_CTACHQ",		REC->E1_CTACHQ,		nil })
			aadd(_aEstruSE1, {"E1_EMITCHQ",		REC->E1_EMITCHQ,	nil })
			
			//----> RECEBIMENTO EM CHEQUE A VISTA
		ElseIf Alltrim(REC->E1_TIPO) $"CH"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
			aadd(_aEstruSE1, {"E1_BCOCHQ",		REC->E1_BCOCHQ,		nil })
			aadd(_aEstruSE1, {"E1_AGECHQ",		REC->E1_AGECHQ,		nil })
			aadd(_aEstruSE1, {"E1_CTACHQ",		REC->E1_CTACHQ,		nil })
			aadd(_aEstruSE1, {"E1_EMITCHQ",		REC->E1_EMITCHQ,	nil })
			
			//----> RECEBIMENTO EM CARTAO DE DEBITO
		ElseIf Alltrim(REC->E1_TIPO) $"CD"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
			aadd(_aEstruSE1, {"E1_DECRESC",		REC->E1_DECRESC,	nil })
			
			//----> RECEBIMENTO EM CARTAO DE CREDITO
		ElseIf Alltrim(REC->E1_TIPO) $"CC"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
			aadd(_aEstruSE1, {"E1_DECRESC",		REC->E1_DECRESC,	nil })
			
			//----> RECEBIMENTO EM CONVENIO
		ElseIf Alltrim(REC->E1_TIPO) $"CO"
			aadd(_aEstruSE1, {"E1_FILIAL",		xFilial("SE1"),		nil })
			aadd(_aEstruSE1, {"E1_PREFIXO",		REC->E1_PREFIXO,	nil })
			aadd(_aEstruSE1, {"E1_NUM",			REC->E1_NUM,		nil })
			aadd(_aEstruSE1, {"E1_PARCELA",		REC->E1_PARCELA,	nil })
			aadd(_aEstruSE1, {"E1_TIPO",		REC->E1_TIPO,		nil })
			aadd(_aEstruSE1, {"E1_NATUREZ",		REC->E1_NATUREZ,	nil })
			aadd(_aEstruSE1, {"E1_CLIENTE",		REC->E1_CLIENTE,	nil })
			aadd(_aEstruSE1, {"E1_LOJA",		REC->E1_LOJA,		nil })
			aadd(_aEstruSE1, {"E1_EMISSAO",		REC->E1_EMISSAO,	nil })
			aadd(_aEstruSE1, {"E1_VENCTO",		REC->E1_VENCTO,		nil })
			aadd(_aEstruSE1, {"E1_VENCREA",		REC->E1_VENCREA,	nil })
			aadd(_aEstruSE1, {"E1_VALOR",		REC->E1_VALOR,		nil })
			aadd(_aEstruSE1, {"E1_MOEDA",		1,					nil })
			aadd(_aEstruSE1, {"E1_VENCORI",		REC->E1_VENCORI,	nil })
			aadd(_aEstruSE1, {"E1_SALDO",		REC->E1_SALDO,		nil })
			aadd(_aEstruSE1, {"E1_VLCRUZ",		REC->E1_VLCRUZ,		nil })
		EndIf
		
		lMsErroAuto := .F.
		MsExecAuto({|x,y| FINA040(x,y)}, _aEstruSE1, 3)
		
		If lMsErroAuto
			If Aviso( "Pergunta", "Recebimento Fórmula Certa não incluído. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atenção" ) == 1
				MostraErro()
			EndIf
		EndIf
		
		dbSelectArea("REC")
		dbSkip()
	EndDo
	
	dbSelectArea("REC")
	dbCloseArea("REC")
	
	//----> ARQUIVO DO CONTAS A PAGAR
Else
	
	_cArquivo	:=	cGetFile("Arquivos Dbase|*.dbf",OemToAnsi("Selecione o Arquivo a Importar"),,,.t.)

	_nQtde		:=	Len(_cArquivo)

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

	CpyT2S(_cArquivo,_cStartPath)
	
	_cArquivo	:= _cStartPath+_cNome
	
	dbUseArea(.t.,"DBFCDXADS",_cArquivo ,"PAG",.f.,.f.)
	
	dbSelectArea("PAG")
	dbGoTop()
	ProcRegua(RecCount())
	
	While Eof() == .f.
		
		IncProc("Processando Registros de Contas a Pagar do Sistema Fórmula Certa "+StrZero(PAGno(),10))
		
		
		dbSelectArea("SE2")
		dbSetOrder(1)
		If dbSeek(PAG->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA),.F.)
			
			RecLock("PAG",.F.)
			PAG->E2_PARCELA		:=	SOMA1(PAG->E2_PARCELA)
			MsUnLock()
			
		EndIf
		
		aadd(_aEstruSE2, {"E2_FILIAL",		xFilial("SE2"),		nil })
		aadd(_aEstruSE2, {"E2_PREFIXO",		PAG->E2_PREFIXO,	nil })
		aadd(_aEstruSE2, {"E2_NUM",			PAG->E2_NUM,		nil })
		aadd(_aEstruSE2, {"E2_PARCELA",		PAG->E2_PARCELA,	nil })
		aadd(_aEstruSE2, {"E2_TIPO",		PAG->E2_TIPO,		nil })
		aadd(_aEstruSE2, {"E2_NATUREZ",		PAG->E2_NATUREZ,	nil })
		aadd(_aEstruSE2, {"E2_FORNECE",		PAG->E2_FORNECE,	nil })
		aadd(_aEstruSE2, {"E2_LOJA",		PAG->E2_LOJA,		nil })
		aadd(_aEstruSE2, {"E2_EMISSAO",		PAG->E2_EMISSAO,	nil })
		aadd(_aEstruSE2, {"E2_VENCTO",		PAG->E2_VENCTO,		nil })
		aadd(_aEstruSE2, {"E2_VENCREA",		PAG->E2_VENCREA,	nil })
		aadd(_aEstruSE2, {"E2_VALOR",		PAG->E2_VALOR,		nil })
		aadd(_aEstruSE2, {"E2_MOEDA",		1,					nil })
		aadd(_aEstruSE2, {"E2_VENCORI",		PAG->E2_VENCORI,	nil })
		aadd(_aEstruSE2, {"E2_SALDO",		PAG->E2_SALDO,		nil })
		aadd(_aEstruSE2, {"E2_VLCRUZ",		PAG->E2_VLCRUZ,		nil })
		
		lMsErroAuto := .F.
		MsExecAuto({|x,y| FINA050(x,y)}, _aEstruSE2, 3)
		
		If lMsErroAuto
			If Aviso( "Pergunta", "Pagamento Fórmula Certa não incluído. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atenção" ) == 1
				MostraErro()
			EndIf
		EndIf
		
		dbSelectArea("PAG")
		dbSkip()
	EndDo
	
	dbSelectArea("PAG")
	dbCloseArea("PAG")
	
EndIf

Return
