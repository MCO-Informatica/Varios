#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ F100TOK  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 18/05/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Obrigatoriedade do Centro de Custo - Movimentacao Banco ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Shangri-la Industria e Comercio de Espanadores Ltda            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F100TOK()

Local _lRet	:=	.t.


If !Empty(M->E5_DEBITO) .And. Subs(M->E5_DEBITO,1,1)$"5"
	If Empty(M->E5_CCD)
		Help(" ",1,"CCOBRIGALL")
		_lRet	:=	.f.
	EndIf
EndIf

If !Empty(M->E5_CREDITO) .And. Subs(M->E5_CREDITO,1,1)$"5"
	If Empty(M->E5_CCC)
		Help(" ",1,"CCOBRIGALL")
		_lRet	:=	.f.
	EndIf
EndIf

/*
//----> VERIFICA SE NAO FOI INFORMADO CONTA DEBITO
If Empty(M->E5_DEBITO)
	MsgBox("A Conta Débito não pode ficar vazia, pois irá influênciar na Integração Contábil."+Chr(13)+Chr(10),"Conta Débito","Stop")
	_lRet	:=	.f.
EndIf

//----> VERIFICA SE NAO FOI INFORMADO CONTA CREDITO
If Empty(M->E5_CREDITO)
	MsgBox("A Conta Crédito não pode ficar vazia, pois irá influênciar na Integração Contábil."+Chr(13)+Chr(10),"Conta Crédito","Stop")
	_lRet	:=	.f.
EndIf

//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (DEBITO)
If _lRet .And. Subs(M->E5_DEBITO,1,1)$"34"
	_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E5_DEBITO,"CT1_RGNV1")
	_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E5_CCD,"CTT_CRGNV1")
	
	//----> VERIFICA AMARRACAO
	If _cCT1 != _cCTT
		MsgBox("A Conta Débito não aceita lançamentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Contábil x Centro de Custo","Stop")
		_lRet	:=	.f.
	EndIf
EndIf

//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (CREDITO)
If _lRet .And. Subs(M->E5_CREDITO,1,1)$"34"                                              
	_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E5_CREDITO,"CT1_RGNV1")
	_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E5_CCC,"CTT_CRGNV1")
	
	//----> VERIFICA AMARRACAO
	If _cCT1 != _cCTT
		MsgBox("A Conta Crédito não aceita lançamentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Contábil x Centro de Custo","Stop")
		_lRet	:=	.f.
	EndIf
EndIf

If MsgBox("Deseja Imprimir Contrato de Mútuo?","Contrato de Mútuo","YesNo")
	U_RFINR05()		//----> INTEGRACAO WORD CONTRATO DE MUTUO
EndIf
*/

Return(_lRet)