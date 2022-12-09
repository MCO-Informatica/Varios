#Include "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � F100TOK  � Autor � Ricardo Correa de Souza � Data � 18/05/2011 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Valida Obrigatoriedade do Centro de Custo - Movimentacao Banco ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Shangri-la Industria e Comercio de Espanadores Ltda            ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
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
	MsgBox("A Conta D�bito n�o pode ficar vazia, pois ir� influ�nciar na Integra��o Cont�bil."+Chr(13)+Chr(10),"Conta D�bito","Stop")
	_lRet	:=	.f.
EndIf

//----> VERIFICA SE NAO FOI INFORMADO CONTA CREDITO
If Empty(M->E5_CREDITO)
	MsgBox("A Conta Cr�dito n�o pode ficar vazia, pois ir� influ�nciar na Integra��o Cont�bil."+Chr(13)+Chr(10),"Conta Cr�dito","Stop")
	_lRet	:=	.f.
EndIf

//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (DEBITO)
If _lRet .And. Subs(M->E5_DEBITO,1,1)$"34"
	_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E5_DEBITO,"CT1_RGNV1")
	_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E5_CCD,"CTT_CRGNV1")
	
	//----> VERIFICA AMARRACAO
	If _cCT1 != _cCTT
		MsgBox("A Conta D�bito n�o aceita lan�amentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Cont�bil x Centro de Custo","Stop")
		_lRet	:=	.f.
	EndIf
EndIf

//----> VERIFICA AMARRACAO CONTA CONTABIL x CENTRO DE CUSTO (CREDITO)
If _lRet .And. Subs(M->E5_CREDITO,1,1)$"34"                                              
	_cCT1	:=	Posicione("CT1",1,xFilial("CT1")+M->E5_CREDITO,"CT1_RGNV1")
	_cCTT	:=	Posicione("CTT",1,xFilial("CTT")+M->E5_CCC,"CTT_CRGNV1")
	
	//----> VERIFICA AMARRACAO
	If _cCT1 != _cCTT
		MsgBox("A Conta Cr�dito n�o aceita lan�amentos neste Centro de Custo."+Chr(13)+Chr(10),"Conta Cont�bil x Centro de Custo","Stop")
		_lRet	:=	.f.
	EndIf
EndIf

If MsgBox("Deseja Imprimir Contrato de M�tuo?","Contrato de M�tuo","YesNo")
	U_RFINR05()		//----> INTEGRACAO WORD CONTRATO DE MUTUO
EndIf
*/

Return(_lRet)