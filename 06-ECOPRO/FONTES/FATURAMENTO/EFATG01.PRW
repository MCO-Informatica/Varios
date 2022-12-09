#include "TOTVS.ch"
#include "rwmake.ch"
#include "Topconn.ch"

User Function EFATG01()

Local _cProduto := TMP1->CK_PRODUTO
Local _cLocal   := TMP1->CK_LOCAL
Local _nEstoque := 0

    dbSelectArea("SB2")
	SB2->(dbSetOrder(1))
    SB2->(DbGoTop())

    //ALERT(ALIAS())
	If SB2->(dbSeek(xFilial("SB2")+_cProduto+_cLocal,.f.))
		_nEstoque	:=	SaldoSB2() - SB2->B2_QPEDVEN
	EndIf			
		
Return(_nEstoque) 


