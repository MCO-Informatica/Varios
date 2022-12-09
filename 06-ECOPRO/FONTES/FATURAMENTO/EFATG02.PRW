#include "TOTVS.ch"
#include "rwmake.ch"
#include "Topconn.ch"

User Function EFATG02()

Local _cProduto := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"})]
Local _cLocal   := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"})]
Local _nEstoque := 0

    dbSelectArea("SB2")
	SB2->(dbSetOrder(1))
    SB2->(DbGoTop())

    //ALERT(ALIAS())
	If SB2->(dbSeek(xFilial("SB2")+_cProduto+_cLocal,.f.))
		_nEstoque	:=	SaldoSB2() - SB2->B2_QPEDVEN
	EndIf			
		
Return(_nEstoque) 


