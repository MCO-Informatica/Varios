#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100LOK ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 17/05/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Valida a Digitacao do Centro de Custo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Shangri-la Industria e Comercio de Espanadores Ltda            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
   		MsgStop("TES informada fora do range 200 à 299 não é permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. !Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado fora do range P0 à P9 não é permitido.","Armazém Errado")
   		_lRet := .f.
   	EndIf
ElseIf !Subs(_cProduto,1,1)$"Z"
 	If _cTES >= '200' .And. _cTES <= '299' .And. Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S"
   		MsgStop("TES informada dentro do range 200 à 299 não permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado dentro do range P0 à P9 não é permitido.","Armazém Errado")
   		_lRet := .f.
   	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)
