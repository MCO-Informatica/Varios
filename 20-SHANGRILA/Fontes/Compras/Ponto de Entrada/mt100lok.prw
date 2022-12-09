#include "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � MT100LOK � Autor � Ricardo Correa de Souza � Data � 17/05/2011 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao �Valida a Digitacao do Centro de Custo                           ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Shangri-la Industria e Comercio de Espanadores Ltda            ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function MT100LOK()

Local _lRet		:=	.t.
Local _aArea    :=	GetArea()
Local _cCusto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_CC"})]
//Local _cTpSrv	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_ITEMCTA"})]
//Local _cUnNeg	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_CLVL"})]
Local _cConta	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_CONTA"})]
Local _cTES		:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_TES"})]
Local _cProduto	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_COD"})]
Local _cLocal	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "D1_LOCAL"})]

//----> VERIFICA SE FOI INFORMADO CENTRO DE CUSTO DEBITO
If Subs(_cConta,1,1)$"5"
	If Empty(_cCusto)
		Help(" ",1,"CCOBRIGALL")
		_lRet	:=	.f.
	EndIf

EndIf

If Subs(_cProduto,1,1)$"Z"
 	If _cTES < '200' .Or. _cTES > '299'
   		MsgStop("TES informada fora do range 200 � 299 n�o � permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. !Subs(_cLocal,1,1)$"P"
   		MsgStop("Armaz�m informado fora do range P0 � P9 n�o � permitido.","Armaz�m Errado")
   		_lRet := .f.
   	EndIf
ElseIf !Subs(_cProduto,1,1)$"Z"
 	If _cTES >= '200' .And. _cTES <= '299' .And. Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S"
   		MsgStop("TES informada dentro do range 200 � 299 n�o permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. Subs(_cLocal,1,1)$"P"
   		MsgStop("Armaz�m informado dentro do range P0 � P9 n�o � permitido.","Armaz�m Errado")
   		_lRet := .f.
   	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)
