#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT410BRW ³ Autor ³     Rafael de Souza     ³ Data ³ 08/02/2011 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Bloqueio do campo c6_prcven(preco unitario) para os Represent. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Bloqueio apenas para os representantes                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ricaelle Industria e Comercio Ltda                             ³±±
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
User Function RFATG11()
Local i:=0
Local _aArea := GetArea()
Local _cGrupo:= ""
Local cMSG:= ""
Local _nValor := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRCVEN"  })]
Local _aGrupo := UsrRetGrp(,RetCodUsr())
Local _cGrupo := Iif(__cUserID$"000000","000001",_aGrupo[1])

_nVal :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT" })]

If Alltrim(_cGrupo)$"000001"
	_nValor :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:=_nValor
	//aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCTAB" })]	:=_nValor
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]	:=A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * _nValor,"C6_VALOR")

Else
	MsgAlert("Usuário sem permissão para alterar o preço de venda.","Atenção!")
		
	_nValor :=_nVal                                         
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:=_nValor
	//aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCTAB" })]	:=_nValor
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]	:=A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * _nValor,"C6_VALOR")
	
EndIf

RestArea(_aArea)

Return(_nValor)
