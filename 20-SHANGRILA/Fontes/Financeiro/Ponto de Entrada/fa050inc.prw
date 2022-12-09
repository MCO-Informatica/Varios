#Include "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � FA050INC � Autor � Ricardo Correa de Souza � Data � 18/05/2011 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Valida Obrigatoriedade do Centro de Custo - Contas a Pagar     ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Shangri-la Industria e Comercio de Espanadores Ltda		      ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
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
		MsgBox("A Conta D�bito n�o pode ficar vazia, pois ir� influ�nciar na Integra��o Cont�bil."+Chr(13)+Chr(10),"Conta D�bito","Stop")
		_lRet	:=	.f.
	EndIf
	
	//----> VERIFICA SE NAO FOI INFORMADO CONTA CREDITO
	If Empty(M->E2_CREDIT)
		MsgBox("A Conta Cr�dito n�o pode ficar vazia, pois ir� influ�nciar na Integra��o Cont�bil."+Chr(13)+Chr(10),"Conta Cr�dito","Stop")
		_lRet	:=	.f.
	EndIf
	
	//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (DEBITO)
	If _lRet .And. Subs(M->E2_DEBITO,1,1)$"34"
		_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E2_DEBITO,"CT1_RGNV1")
		_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E2_CCD,"CTT_CRGNV1")
		
		//----> VERIFICA AMARRACAO
		If _cCT1 != _cCTT
			MsgBox("A Conta D�bito n�o aceita lan�amentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Cont�bil x Centro de Custo","Stop")
			_lRet	:=	.f.
		EndIf
	EndIf
	
	//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (CREDITO)
	If _lRet .And. Subs(M->E2_CREDIT,1,1)$"34"
		_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E2_CREDIT,"CT1_RGNV1")
		_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E2_CCC,"CTT_CRGNV1")
		
		//----> VERIFICA AMARRACAO
		If _cCT1 != _cCTT
			MsgBox("A Conta Cr�dito n�o aceita lan�amentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Cont�bil x Centro de Custo","Stop")
			_lRet	:=	.f.
		EndIf
	EndIf
	*/
EndIf

Return(_lRet)
