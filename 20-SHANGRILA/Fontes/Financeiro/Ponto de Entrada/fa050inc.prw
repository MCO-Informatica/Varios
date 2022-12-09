#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FA050INC ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 18/05/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Obrigatoriedade do Centro de Custo - Contas a Pagar     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Shangri-la Industria e Comercio de Espanadores Ltda		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()

Local _lRet	:=	.t.

//----> VERIFICA SE UTILIZA RATEIO CONTAS A PAGAR
If M->E2_RATEIO$"N" .and. !SUBS(M->E2_ORIGEM,1,3)$"GPE"
	
	//----> VERIFICA SE FOI INFORMADO CENTRO DE CUSTO DEBITO
	If !Empty(M->E2_DEBITO) .And. Subs(M->E2_DEBITO,1,1)$"5"
		If Empty(M->E2_CCD)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf
        
		/*
		If Empty(M->E2_CLVLDB)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf

		If Empty(M->E2_ITEMD)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf
		*/
	EndIf
	
	
	//----> VERIFICA SE FOI INFORMADO CENTRO DE CUSTO CREDITO
	If !Empty(M->E2_CREDIT) .And. Subs(M->E2_CREDIT,1,1)$"5"
		If Empty(M->E2_CCC)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf

		/*
		If Empty(M->E2_CLVLCR)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf

		If Empty(M->E2_ITEMC)
			Help(" ",1,"CCOBRIGALL")
			_lRet	:=	.f.
		EndIf
		*/
	EndIf
	
	/*
	//----> VERIFICA SE NAO FOI INFORMADO CONTA DEBITO
	If Empty(M->E2_DEBITO)
		MsgBox("A Conta Débito não pode ficar vazia, pois irá influênciar na Integração Contábil."+Chr(13)+Chr(10),"Conta Débito","Stop")
		_lRet	:=	.f.
	EndIf
	
	//----> VERIFICA SE NAO FOI INFORMADO CONTA CREDITO
	If Empty(M->E2_CREDIT)
		MsgBox("A Conta Crédito não pode ficar vazia, pois irá influênciar na Integração Contábil."+Chr(13)+Chr(10),"Conta Crédito","Stop")
		_lRet	:=	.f.
	EndIf
	
	//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (DEBITO)
	If _lRet .And. Subs(M->E2_DEBITO,1,1)$"34"
		_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E2_DEBITO,"CT1_RGNV1")
		_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E2_CCD,"CTT_CRGNV1")
		
		//----> VERIFICA AMARRACAO
		If _cCT1 != _cCTT
			MsgBox("A Conta Débito não aceita lançamentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Contábil x Centro de Custo","Stop")
			_lRet	:=	.f.
		EndIf
	EndIf
	
	//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (CREDITO)
	If _lRet .And. Subs(M->E2_CREDIT,1,1)$"34"
		_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E2_CREDIT,"CT1_RGNV1")
		_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E2_CCC,"CTT_CRGNV1")
		
		//----> VERIFICA AMARRACAO
		If _cCT1 != _cCTT
			MsgBox("A Conta Crédito não aceita lançamentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Contábil x Centro de Custo","Stop")
			_lRet	:=	.f.
		EndIf
	EndIf
	*/
EndIf

Return(_lRet)
